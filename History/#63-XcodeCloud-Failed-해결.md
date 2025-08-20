
### 주요 에러 발생 로그 분석

```
❗️mise install

...

asdf-tuist: Could not download https://github.com/tuist/tuist/releases/download/4.17.0/tuist.zip

[31mmise[0m [31mERROR[0m Failed to install tool: tuist@4.17.0

Individual error details:

  1. tuist@4.17.0:

     Error {

         msg: "failed to install asdf:mise-plugins/mise-tuist@4.17.0",

         source: ScriptFailed(

             "~/.local/share/mise/plugins/tuist/bin/download",

             Some(

                 ExitStatus(

                     unix_wait_status(

                         256,

                     ),

                 ),

             ),

         ),

     }

[31mmise[0m [31mERROR[0m [2mRun with --verbose or MISE_VERBOSE=1 for more information[0m

Error
Command exited with non-zero exit-code: 1

Warning
Running ci_post_clone.sh script failed (exited with code 1). Executable scripts are run using the interpreter specified in the shebang line. 
```

> ci_post_clone.sh에서 현재 brew로 mise를 설치하는 것을 curl 로 설치하는 명령어로 변경