
" Delete the next line to avoid the special indention of items
if !exists("g:org_indent_from_head")
  let g:org_indent_from_head = 0

endif

if exists("b:did_indent") | finish
endif
let b:did_indent = 1


setlocal indentexpr=GetOrgIndent()
setlocal nolisp
setlocal nosmartindent
setlocal autoindent
"setlocal indentkeys+=},=\\item,=\\bibitem


" Only define the function once
"if exists("GetOrgIndent") | finish
"endif



function! GetOrgIndent(...)
  " Find a non-blank line above the current line.
  "let lnum = prevnonblank(v:lnum - 1)
  let lnum = PrevNonBlank(v:lnum - 1)
  
  " At the start of the file use zero indent.
  if lnum == 0 | return 0 
  endif

  let curline = getline(v:lnum)          " current line
  "let lminusone = getline(v:lnum-1)
  "if b:last_lnum > 0) && (curline !~ '^\s*$')
"	  let lnum = b:last_lnum
"	  let b:last_lnum = 0
 " endif
  let ind = indent(lnum)

  if b:suppress_list_indent == 1
	  let prevline = getline(lnum)             " previous line
  else
	  let prevline = getline(prevnonblank(v:lnum-1))
  endif

  if (curline =~ '^\s*$') && (b:suppress_list_indent == 1)
	  let b:suppress_list_indent = 0
	  let b:org_list_offset=0
  endif

  if (curline =~ '^\*\+ ') 
	  let ind = 0
	  " below lines are failsafes, hopefully redundant
	  let b:suppress_list_indent=0
	  let b:suppress_indent=0
  elseif curline =~ '#+begin_'
	  let b:suppress_indent=1
	  let ind = 0
  elseif curline =~ '#+end_'
	  let b:suppress_indent=0
	  let ind = 0
  elseif curline =~ '^#+'
	  let ind = 0
  "elseif (curline =~ '^\s*$') && (b:suppress_list_indent == 1)
"			  \ && (len(synstack(v:lnum-1,1))>0) 
"			  \ && (synIDattr(synstack(v:lnum-1,1)[0],'name') == 'orgList')
"	  let b:suppress_list_indent = 0
  elseif b:suppress_indent == 1
	  return indent(curline)
  elseif b:suppress_list_indent == 1
	  return len(matchstr(curline,'^\s*')) + b:org_list_offset
  elseif (curline =~ '^\s*\(\d\+[.):]\|[-+] \)') 
	  let before_ind = len(matchstr(curline,'^\s*'))
	  "let ind= ind
	  let b:org_list_offset = ind - before_ind 
	  let b:suppress_list_indent = 1
  elseif (curline =~'^\s*\d\+[).:]\s\+\S') || (curline =~'^\s*[-+\*]\s\+\S')
"	  if len(curline)>0
		  let ind = indent(curline)
"	  endif
  elseif prevline =~ '^\*\+ '
    let ind = len(matchstr(prevline,'^\*\+ ')) + g:org_indent_from_head
  elseif prevline =~ '^\s*\d\+[).\]:]\s\+\S'
    let ind = ind + len(matchstr(prevline,'^\s*\zs\d\+[).\]:]\s\+\ze\S'))
  elseif prevline =~ '^\s*[-+\*]\s\+\S'
    let ind = ind + len(matchstr(prevline,'^\s*\zs[-+\*]\s\+\ze\S'))
  elseif (len(synstack(v:lnum,1))>0) && (synIDattr(synstack(v:lnum,1)[0],'name') == 'orgList')
    let ind = len(matchstr(getline(v:lnum-1),'^\s*'))
  endif

  return ind
endfunction

function! PrevNonBlank(line) 
	let line = prevnonblank(a:line)
	 
	if (len(synstack(line,1))>0) && (synIDattr(synstack(line,1)[0],'name') == 'orgLisp')
		execute line + 1
		let line = search('^#+begin_src','nb')-1
	elseif (len(synstack(line-1,1))>0) && (synIDattr(synstack(line-1,1)[0],'name') == 'orgList')
		execute line - 1
		let line = search('^\s*$','nb')-1

	endif
	return prevnonblank(line)
endfunction

function! GetTestIndent2(lnum)
  " Find a non-blank line above the current line.
  "let lnum = prevnonblank(a:lnum - 1)
  let lnum = PrevNonBlank(a:lnum - 1)
  
  " At the start of the file use zero indent.
  if lnum == 0 | return 0 
  endif

  let curline = getline(a:lnum)          " current line
  "let lminusone = getline(a:lnum-1)
  "if b:last_lnum > 0) && (curline !~ '^\s*$')
"	  let lnum = b:last_lnum
"	  let b:last_lnum = 0
 " endif
  let ind = indent(lnum)

  if b:suppress_list_indent == 1
	  let prevline = getline(lnum)             " previous line
  else
	  let prevline = getline(prevnonblank(a:lnum-1))
  endif

  if (curline =~ '^\s*$') && (b:suppress_list_indent == 1)
	  let b:suppress_list_indent = 0
	  let b:org_list_offset=0
  endif

  if (curline =~ '^\*\+ ') 
	  let ind = 0
	  " below lines are failsafes, hopefully redundant
	  let b:suppress_list_indent=0
	  let b:suppress_indent=0
  elseif curline =~ '#+begin_'
	  let b:suppress_indent=1
	  let ind = 0
  elseif curline =~ '#+end_'
	  let b:suppress_indent=0
	  let ind = 0
  "elseif (curline =~ '^\s*$') && (b:suppress_list_indent == 1)
"			  \ && (len(synstack(a:lnum-1,1))>0) 
"			  \ && (synIDattr(synstack(a:lnum-1,1)[0],'name') == 'orgList')
"	  let b:suppress_list_indent = 0
  elseif b:suppress_indent == 1
	  return indent(curline)
  elseif b:suppress_list_indent == 1
	  return len(matchstr(curline,'^\s*')) + b:org_list_offset
  elseif (curline =~ '^\s*\(\d\+[.):]\|[-+] \)') 
	  let before_ind = len(matchstr(curline,'^\s*'))
	  "let ind= ind
	  let b:org_list_offset = ind - before_ind 
	  let b:suppress_list_indent = 1
  elseif (curline =~'^\s*\d\+[).:]\s\+\S') || (curline =~'^\s*[-+\*]\s\+\S')
"	  if len(curline)>0
		  let ind = indent(curline)
"	  endif
  elseif prevline =~ '^\*\+ '
    let ind = len(matchstr(prevline,'^\*\+ ')) + g:org_indent_from_head
  elseif prevline =~ '^\s*\d\+[).\]:]\s\+\S'
    let ind = ind + len(matchstr(prevline,'^\s*\zs\d\+[).\]:]\s\+\ze\S'))
  elseif prevline =~ '^\s*[-+\*]\s\+\S'
    let ind = ind + len(matchstr(prevline,'^\s*\zs[-+\*]\s\+\ze\S'))
  elseif (len(synstack(a:lnum,1))>0) && (synIDattr(synstack(a:lnum,1)[0],'name') == 'orgList')
    let ind = len(matchstr(getline(a:lnum-1),'^\s*'))
  endif

  return ind
endfunction

function! GetTestIndent(lnum)
  " Find a non-blank line above the current line.
  "let lnum = prevnonblank(a:lnum - 1)
  let lnum = PrevNonBlank(a:lnum - 1)
  
  " At the start of the file use zero indent.
  if lnum == 0 | return 0 
  endif

  let curline = getline(a:lnum)          " current line
  "let lminusone = getline(a:lnum-1)
  "if b:last_lnum > 0) && (curline !~ '^\s*$')
"	  let lnum = b:last_lnum
"	  let b:last_lnum = 0
 " endif
  let ind = indent(lnum)
  if b:suppress_list_indent == 1
	  let prevline = getline(lnum)             " previous line
  else
	  let prevline = getline(prevnonblank(v:lnum-1))
  endif

  if (curline =~ '^\s*$') && (b:suppress_list_indent == 1)
	  let b:suppress_list_indent = 0
	  let b:org_list_offset=0
  endif

  if (curline =~ '^\*\+ ') 
	  let ind = 0
	  " below lines are failsafes, hopefully redundant
	  let b:suppress_list_indent=0
	  let b:suppress_indent=0
  elseif curline =~ '#+begin_'
	  let b:suppress_indent=1
	  let ind = 0
  elseif curline =~ '#+end_'
	  let b:suppress_indent=0
	  let ind = 0
  "elseif (curline =~ '^\s*$') && (b:suppress_list_indent == 1)
"			  \ && (len(synstack(a:lnum-1,1))>0) 
"			  \ && (synIDattr(synstack(a:lnum-1,1)[0],'name') == 'orgList')
"	  let b:suppress_list_indent = 0
  elseif b:suppress_indent == 1
	  return indent(curline)
  elseif b:suppress_list_indent == 1
	  return len(matchstr(curline,'^\s*')) + b:org_list_offset
  elseif (curline =~ '^\s*\(\d\+[.):]\|[-+] \)') 
	  let before_ind = len(matchstr(curline,'^\s*'))
	  "let ind= ind
	  let b:org_list_offset = ind - before_ind 
	  let b:suppress_list_indent = 1
  elseif (curline =~'^\s*\d\+[).:]\s\+\S') || (curline =~'^\s*[-+\*]\s\+\S')
"	  if len(curline)>0
		  let ind = indent(curline)
"	  endif
  elseif prevline =~ '^\*\+ '
    let ind = len(matchstr(prevline,'^\*\+ ')) + g:org_indent_from_head
  elseif prevline =~ '^\s*\d\+[).\]:]\s\+\S'
    let ind = ind + len(matchstr(prevline,'^\s*\zs\d\+[).\]:]\s\+\ze\S'))
  elseif prevline =~ '^\s*[-+\*]\s\+\S'
    let ind = ind + len(matchstr(prevline,'^\s*\zs[-+\*]\s\+\ze\S'))
  endif

  return ind
endfunction

