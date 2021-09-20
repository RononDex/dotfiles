" Set test stragety

if filereadable("./gradlew")
    let test#java#runner = 'gradletest'
    let test#java#gradletest#executable = './gradlew test'
endif


function! JavaStartDebugCallback(err, port)
  execute "cexpr! 'Java debug started on port: " . a:port . "'"
  call vimspector#LaunchWithSettings({ "configuration": "Java Attach", "AdapterPort": a:port })
endfunction

function JavaStartDebug()
  call CocActionAsync('runCommand', 'vscode.java.startDebugSession', function('JavaStartDebugCallback'))
endfunction

augroup omnisharp_commands
    autocmd!

    autocmd FileType java nmap <F5> :call JavaStartDebug()<CR>
augroup END
