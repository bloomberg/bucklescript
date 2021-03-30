
type  node = 
  | Dir of string *  node list 
  | File of string *  string  
let root = ([
   Dir("basic",[
    File(".gitignore",
    "*.exe\n\
    *.obj\n\
    *.out\n\
    *.compile\n\
    *.native\n\
    *.byte\n\
    *.cmo\n\
    *.annot\n\
    *.cmi\n\
    *.cmx\n\
    *.cmt\n\
    *.cmti\n\
    *.cma\n\
    *.a\n\
    *.cmxa\n\
    *.obj\n\
    *~\n\
    *.annot\n\
    *.cmj\n\
    *.bak\n\
    lib/bs\n\
    *.mlast\n\
    *.mliast\n\
    .vscode\n\
    .merlin\n\
    .bsb.lock\n\
    /node_modules/\n\
    "
    );
    File("README.md",
    "\n\
    \n\
    # Build\n\
    ```\n\
    npm run build\n\
    ```\n\
    \n\
    # Watch\n\
    \n\
    ```\n\
    npm run watch\n\
    ```\n\
    \n\
    "
    );
    File("bsconfig.json",
    "{\n\
    \  \"name\": \"${rescript:name}\",\n\
    \  \"version\": \"${rescript:proj-version}\",\n\
    \  \"sources\": {\n\
    \    \"dir\" : \"src\",\n\
    \    \"subdirs\" : true\n\
    \  }\n\
    }\n\
    "
    );
    File("package.json",
    "{\n\
    \  \"name\": \"${rescript:name}\",\n\
    \  \"version\": \"${rescript:proj-version}\",\n\
    \  \"scripts\": {\n\
    \    \"clean\": \"bsb -clean-world\",\n\
    \    \"build\": \"bsb -make-world\",\n\
    \    \"watch\": \"bsb -make-world -w\"\n\
    \  },\n\
    \  \"keywords\": [\n\
    \    \"ReScript\"\n\
    \  ],\n\
    \  \"author\": \"\",\n\
    \  \"license\": \"MIT\",\n\
    \  \"devDependencies\": {\n\
    \    \"${rescript:platform}\": \"^${rescript:bs-version}\"\n\
    \  }\n\
    }"
    );
    Dir("src",[
     File("demo.res",
     "\n\
     Js.log(\"Hello, ReScript\")"
     )        
    ])        
   ]);
   Dir("basic-reason",[
    File(".gitignore",
    ".DS_Store\n\
    .merlin\n\
    .bsb.lock\n\
    npm-debug.log\n\
    /lib/bs/\n\
    /node_modules/\n\
    "
    );
    File("README.md",
    "# Basic Reason Template\n\
    \n\
    Hello! This project allows you to quickly get started with ReScript using Reason syntax. If you wanted a more sophisticated version, try the `react` template (`bsb -theme react -init .`).\n\
    \n\
    # Build\n\
    \n\
    ```bash\n\
    # for yarn\n\
    yarn build\n\
    \n\
    # for npm\n\
    npm run build\n\
    ```\n\
    \n\
    # Build + Watch\n\
    \n\
    ```bash\n\
    # for yarn\n\
    yarn start\n\
    \n\
    # for npm\n\
    npm run start\n\
    ```\n\
    \n\
    "
    );
    File("bsconfig.json",
    "{\n\
    \  \"name\": \"${rescript:name}\",\n\
    \  \"version\": \"${rescript:proj-version}\",\n\
    \  \"sources\": {\n\
    \    \"dir\" : \"src\",\n\
    \    \"subdirs\" : true\n\
    \  },\n\
    \  \"package-specs\": {\n\
    \    \"module\": \"commonjs\",\n\
    \    \"in-source\": true\n\
    \  },\n\
    \  \"suffix\": \".bs.js\",\n\
    \  \"bs-dependencies\": [\n\
    \n\
    \  ],\n\
    \  \"warnings\": {\n\
    \    \"error\" : \"+101\"\n\
    \  },\n\
    \  \"namespace\": true,\n\
    \  \"refmt\": 3\n\
    }\n\
    "
    );
    File("package.json",
    "{\n\
    \  \"name\": \"${rescript:name}\",\n\
    \  \"version\": \"${rescript:proj-version}\",\n\
    \  \"scripts\": {\n\
    \    \"build\": \"bsb -make-world\",\n\
    \    \"start\": \"bsb -make-world -w\",\n\
    \    \"clean\": \"bsb -clean-world\"\n\
    \  },\n\
    \  \"keywords\": [\n\
    \    \"ReScript\"\n\
    \  ],\n\
    \  \"author\": \"\",\n\
    \  \"license\": \"MIT\",\n\
    \  \"devDependencies\": {\n\
    \    \"${rescript:platform}\": \"^${rescript:bs-version}\"\n\
    \  }\n\
    }\n\
    "
    );
    Dir("src",[
     File("Demo.re",
     "Js.log(\"Hello, ReScript!\");\n\
     "
     )        
    ])        
   ]);
   Dir("generator",[
    File(".gitignore",
    "*.exe\n\
    *.obj\n\
    *.out\n\
    *.compile\n\
    *.native\n\
    *.byte\n\
    *.cmo\n\
    *.annot\n\
    *.cmi\n\
    *.cmx\n\
    *.cmt\n\
    *.cmti\n\
    *.cma\n\
    *.a\n\
    *.cmxa\n\
    *.obj\n\
    *~\n\
    *.annot\n\
    *.cmj\n\
    *.bak\n\
    lib/bs\n\
    *.mlast\n\
    *.mliast\n\
    .vscode\n\
    .merlin\n\
    .bsb.lock\n\
    /node_modules/\n\
    "
    );
    File("README.md",
    "\n\
    \n\
    # Build\n\
    ```\n\
    npm run build\n\
    ```\n\
    \n\
    # Watch\n\
    \n\
    ```\n\
    npm run watch\n\
    ```\n\
    \n\
    \n\
    # Editor\n\
    If you use `vscode`, Press `Windows + Shift + B` it will build automatically"
    );
    File("bsconfig.json",
    "{\n\
    \  \"name\": \"${rescript:name}\",\n\
    \  \"version\": \"${rescript:proj-version}\",\n\
    \  \"sources\": {\n\
    \    \"dir\": \"src\",\n\
    \    \"generators\": [{\n\
    \      \"name\": \"cpp\",\n\
    \      \"edge\": [\"test.ml\", \":\", \"test.cpp.ml\"]\n\
    \    }],\n\
    \    \"subdirs\": true  \n\
    \  },\n\
    \  \"generators\": [{\n\
    \    \"name\" : \"cpp\",\n\
    \    \"command\": \"sed 's/OCAML/3/' $in > $out\"\n\
    \  }],\n\
    \  \"bs-dependencies\" : [\n\
    \  ]\n\
    }"
    );
    File("package.json",
    "{\n\
    \  \"name\": \"${rescript:name}\",\n\
    \  \"version\": \"${rescript:proj-version}\",\n\
    \  \"scripts\": {\n\
    \    \"clean\": \"bsb -clean-world\",\n\
    \    \"build\": \"bsb -make-world\",\n\
    \    \"watch\": \"bsb -make-world -w\"\n\
    \  },\n\
    \  \"keywords\": [\n\
    \    \"ReScript\"\n\
    \  ],\n\
    \  \"author\": \"\",\n\
    \  \"license\": \"MIT\",\n\
    \  \"devDependencies\": {\n\
    \    \"${rescript:platform}\": \"^${rescript:bs-version}\"\n\
    \  }\n\
    }\n\
    "
    );
    Dir("src",[
     File("demo.ml",
     "\n\
     \n\
     let () = Js.log \"Hello, ReScript\""
     );
     File("test.cpp.ml",
     "\n\
     (* \n\
     #define FS_VAL(name,ty) external name : ty = \"\" [@@bs.module \"fs\"]\n\
     \n\
     \n\
     FS_VAL(readdirSync, string -> string array)\n\
     \ *)\n\
     \n\
     \n\
     \ let ocaml = OCAML"
     )        
    ])        
   ]);
   Dir("minimal",[
    File(".gitignore",
    ".DS_Store\n\
    .merlin\n\
    .bsb.lock\n\
    npm-debug.log\n\
    /lib/bs/\n\
    /node_modules/"
    );
    File("README.md",
    "\n\
    \  # ${rescript:name}"
    );
    File("bsconfig.json",
    "{\n\
    \  \"name\": \"${rescript:name}\",\n\
    \  \"sources\": {\n\
    \      \"dir\": \"src\",\n\
    \      \"subdirs\": true\n\
    \  }\n\
    }"
    );
    File("package.json",
    "{\n\
    \  \"name\": \"${rescript:name}\",\n\
    \  \"version\": \"${rescript:proj-version}\",\n\
    \  \"scripts\": {\n\
    \    \"clean\": \"bsb -clean-world\",\n\
    \    \"build\": \"bsb -make-world\",\n\
    \    \"start\": \"bsb -make-world -w\"\n\
    \  },\n\
    \  \"keywords\": [\n\
    \    \"ReScript\"\n\
    \  ],\n\
    \  \"author\": \"\",\n\
    \  \"license\": \"MIT\",\n\
    \  \"devDependencies\": {\n\
    \    \"${rescript:platform}\": \"^${rescript:bs-version}\"\n\
    \  }\n\
    }\n\
    "
    );
    Dir("src",[
     File("main.ml",
     ""
     )        
    ])        
   ]);
   Dir("node",[
    File(".gitignore",
    "*.exe\n\
    *.obj\n\
    *.out\n\
    *.compile\n\
    *.native\n\
    *.byte\n\
    *.cmo\n\
    *.annot\n\
    *.cmi\n\
    *.cmx\n\
    *.cmt\n\
    *.cmti\n\
    *.cma\n\
    *.a\n\
    *.cmxa\n\
    *.obj\n\
    *~\n\
    *.annot\n\
    *.cmj\n\
    *.bak\n\
    lib/bs\n\
    *.mlast\n\
    *.mliast\n\
    .vscode\n\
    .merlin\n\
    .bsb.lock\n\
    /node_modules/\n\
    "
    );
    File("README.md",
    "\n\
    \n\
    # Build\n\
    ```\n\
    npm run build\n\
    ```\n\
    \n\
    # Watch\n\
    \n\
    ```\n\
    npm run watch\n\
    ```\n\
    \n\
    \n\
    # Editor\n\
    If you use `vscode`, Press `Windows + Shift + B` it will build automatically\n\
    "
    );
    File("bsconfig.json",
    "{\n\
    \  \"name\": \"${rescript:name}\",\n\
    \  \"version\": \"${rescript:proj-version}\",\n\
    \  \"sources\": {\n\
    \      \"dir\": \"src\",\n\
    \      \"subdirs\" : true\n\
    \  },\n\
    \  \"package-specs\": {\n\
    \    \"module\": \"commonjs\",\n\
    \    \"in-source\": true\n\
    \  },\n\
    \  \"suffix\": \".bs.js\",\n\
    \  \"bs-dependencies\": [\n\
    \   ]\n\
    }"
    );
    File("package.json",
    "{\n\
    \  \"name\": \"${rescript:name}\",\n\
    \  \"version\": \"${rescript:proj-version}\",\n\
    \  \"scripts\": {\n\
    \    \"clean\": \"bsb -clean-world\",\n\
    \    \"build\": \"bsb -make-world\",\n\
    \    \"watch\": \"bsb -make-world -w\"\n\
    \  },\n\
    \  \"keywords\": [\n\
    \    \"ReScript\"\n\
    \  ],\n\
    \  \"author\": \"\",\n\
    \  \"license\": \"MIT\",\n\
    \  \"devDependencies\": {\n\
    \    \"${rescript:platform}\": \"^${rescript:bs-version}\"\n\
    \  }\n\
    }\n\
    "
    );
    Dir("src",[
     File("demo.ml",
     "\n\
     \n\
     let () = Js.log \"Hello, ReScript\""
     )        
    ])        
   ]);
   Dir("react-hooks",[
    File(".gitignore",
    ".DS_Store\n\
    .merlin\n\
    .bsb.lock\n\
    npm-debug.log\n\
    /lib/bs/\n\
    /node_modules/\n\
    /bundleOutput/"
    );
    File("README.md",
    "# ReasonReact Template & Examples\n\
    \n\
    This is:\n\
    - A template for your new ReasonReact project.\n\
    - A collection of thin examples illustrating ReasonReact usage.\n\
    - Extra helper documentation for ReasonReact (full ReasonReact docs [here](https://reasonml.github.io/reason-react/)).\n\
    \n\
    `src` contains 4 sub-folders, each an independent, self-contained ReasonReact example. Feel free to delete any of them and shape this into your project! This template's more malleable than you might be used to =).\n\
    \n\
    The point of this template and examples is to let you understand and personally tweak the entirely of it. We **don't** give you an opaque, elaborate mega build setup just to put some boxes on the screen. It strikes to stay transparent, learnable, and simple. You're encouraged to read every file; it's a great feeling, having the full picture of what you're using and being able to touch any part.\n\
    \n\
    ## Run\n\
    \n\
    ```sh\n\
    npm install\n\
    npm run server\n\
    # in a new tab\n\
    npm start\n\
    ```\n\
    \n\
    Open a new web page to `http://localhost:8000/`. Change any `.re` file in `src` to see the page auto-reload. **You don't need any bundler when you're developing**!\n\
    \n\
    **How come we don't need any bundler during development**? We highly encourage you to open up `index.html` to check for yourself!\n\
    \n\
    # Features Used\n\
    \n\
    |                           | Blinking Greeting | Reducer from ReactJS Docs | Fetch Dog Pictures | Reason Using JS Using Reason |\n\
    |---------------------------|-------------------|---------------------------|--------------------|------------------------------|\n\
    | No props                  |                   | ✓                         |                    |                              |\n\
    | Has props                 |                   |                           |                    | ✓                            |\n\
    | Children props            | ✓                 |                           |                    |                              |\n\
    | No state                  |                   |                           |                    | ✓                            |\n\
    | Has state                 | ✓                 |                           |  ✓                 |                              |\n\
    | Has state with useReducer |                   | ✓                         |                    |                              |\n\
    | ReasonReact using ReactJS |                   |                           |                    | ✓                            |\n\
    | ReactJS using ReasonReact |                   |                           |                    | ✓                            |\n\
    | useEffect                 | ✓                 |                           |  ✓                 |                              |\n\
    | Dom attribute             | ✓                 | ✓                         |                    | ✓                            |\n\
    | Styling                   | ✓                 | ✓                         |  ✓                 | ✓                            |\n\
    | React.array               |                   |                           |  ✓                 |                              |\n\
    \n\
    # Bundle for Production\n\
    \n\
    We've included a convenience `UNUSED_webpack.config.js`, in case you want to ship your project to production. You can rename and/or remove that in favor of other bundlers, e.g. Rollup.\n\
    \n\
    We've also provided a barebone `indexProduction.html`, to serve your bundle.\n\
    \n\
    ```sh\n\
    npm install webpack webpack-cli\n\
    # rename file\n\
    mv UNUSED_webpack.config.js webpack.config.js\n\
    # call webpack to bundle for production\n\
    ./node_modules/.bin/webpack\n\
    open indexProduction.html\n\
    ```\n\
    \n\
    # Handle Routing Yourself\n\
    \n\
    To serve the files, this template uses a minimal dependency called `moduleserve`. A URL such as `localhost:8000/scores/john` resolves to the file `scores/john.html`. If you'd like to override this and handle URL resolution yourself, change the `server` command in `package.json` from `moduleserve ./ --port 8000` to `moduleserve ./ --port 8000 --spa` (for \"single page application\"). This will make `moduleserve` serve the default `index.html` for any URL. Since `index.html` loads `Index.bs.js`, you can grab hold of the URL in the corresponding `Index.re` and do whatever you want.\n\
    \n\
    By the way, ReasonReact comes with a small [router](https://reasonml.github.io/reason-react/docs/en/router) you might be interested in.\n\
    "
    );
    File("UNUSED_webpack.config.js",
    "const path = require('path');\n\
    \n\
    module.exports = {\n\
    \  entry: './src/Index.bs.js',\n\
    \  // If you ever want to use webpack during development, change 'production'\n\
    \  // to 'development' as per webpack documentation. Again, you don't have to\n\
    \  // use webpack or any other bundler during development! Recheck README if\n\
    \  // you didn't know this\n\
    \  mode: 'production',\n\
    \  output: {\n\
    \    path: path.join(__dirname, \"bundleOutput\"),\n\
    \    filename: 'index.js',\n\
    \  },\n\
    };"
    );
    File("bsconfig.json",
    "{\n\
    \  \"name\": \"${rescript:name}\",\n\
    \  \"reason\": {\n\
    \    \"react-jsx\": 3\n\
    \  },\n\
    \  \"sources\": {\n\
    \    \"dir\" : \"src\",\n\
    \    \"subdirs\" : true\n\
    \  },\n\
    \  \"bsc-flags\": [\"-bs-super-errors\", \"-bs-no-version-header\"],\n\
    \  \"package-specs\": [{\n\
    \    \"module\": \"commonjs\",\n\
    \    \"in-source\": true\n\
    \  }],\n\
    \  \"suffix\": \".bs.js\",\n\
    \  \"namespace\": true,\n\
    \  \"bs-dependencies\": [\n\
    \    \"reason-react\"\n\
    \  ],\n\
    \  \"refmt\": 3\n\
    }\n\
    "
    );
    File("index.html",
    "<!DOCTYPE html>\n\
    <html lang=\"en\">\n\
    <head>\n\
    \  <meta charset=\"UTF-8\">\n\
    \  <title>ReasonReact Examples</title>\n\
    </head>\n\
    <body>\n\
    \  <script>\n\
    \    // stub a variable ReactJS checks. ReactJS assumes you're using a bundler, NodeJS or similar system that provides it the `process.env.NODE_ENV` variable.\n\
    \    window.process = {\n\
    \      env: {\n\
    \        NODE_ENV: 'development'\n\
    \      }\n\
    \    };\n\
    \  </script>\n\
    \n\
    \  <!-- This is https://github.com/marijnh/moduleserve, the secret sauce that allows us not need to bundle things during development, and have instantaneous iteration feedback, without any hot-reloading or extra build pipeline needed. -->\n\
    \  <script src=\"/moduleserve/load.js\" data-module=\"/src/Index.bs.js\"></script>\n\
    \  <!-- Our little watcher. Super clean. Check it out! -->\n\
    \  <script src=\"/watcher.js\"></script>\n\
    </body>\n\
    </html>\n\
    "
    );
    File("indexProduction.html",
    "<!DOCTYPE html>\n\
    <html lang=\"en\">\n\
    <head>\n\
    \  <meta charset=\"UTF-8\">\n\
    \  <title>ReasonReact Examples</title>\n\
    </head>\n\
    <body>\n\
    \  <script src=\"./bundleOutput/index.js\"></script>\n\
    </body>\n\
    </html>\n\
    "
    );
    File("package.json",
    "{\n\
    \  \"name\": \"${rescript:name}\",\n\
    \  \"version\": \"${rescript:proj-version}\",\n\
    \  \"scripts\": {\n\
    \    \"build\": \"bsb -make-world\",\n\
    \    \"start\": \"bsb -make-world -w -ws _ \",\n\
    \    \"clean\": \"bsb -clean-world\",\n\
    \    \"server\": \"moduleserve ./ --port 8000\",\n\
    \    \"test\": \"echo \\\"Error: no test specified\\\" && exit 1\"\n\
    \  },\n\
    \  \"keywords\": [\n\
    \    \"ReScript\",\n\
    \    \"ReasonReact\",\n\
    \    \"reason-react\"\n\
    \  ],\n\
    \  \"author\": \"\",\n\
    \  \"license\": \"MIT\",\n\
    \  \"dependencies\": {\n\
    \    \"react\": \"^16.8.1\",\n\
    \    \"react-dom\": \"^16.8.1\",\n\
    \    \"reason-react\": \">=0.7.1\"\n\
    \  },\n\
    \  \"devDependencies\": {\n\
    \    \"${rescript:platform}\": \"^${rescript:bs-version}\",\n\
    \    \"moduleserve\": \"^0.9.0\"\n\
    \  }\n\
    }\n\
    "
    );
    Dir("src",[
     Dir("BlinkingGreeting",[
      File("BlinkingGreeting.re",
      "[@react.component]\n\
      let make = (~children) => {\n\
      \  let (show, setShow) = React.useState(() => true);\n\
      \n\
      \  // Notice that instead of `useEffect`, we have `useEffect0`. See\n\
      \  // reasonml.github.io/reason-react/docs/en/components#hooks for more info\n\
      \  React.useEffect0(() => {\n\
      \    let id =\n\
      \      Js.Global.setInterval(\n\
      \        () => setShow(previousShow => !previousShow),\n\
      \        1000,\n\
      \      );\n\
      \n\
      \    Some(() => Js.Global.clearInterval(id));\n\
      \  });\n\
      \n\
      \  let style =\n\
      \    if (show) {\n\
      \      ReactDOMRe.Style.make(~opacity=\"1\", ~transition=\"opacity 1s\", ());\n\
      \    } else {\n\
      \      ReactDOMRe.Style.make(~opacity=\"0\", ~transition=\"opacity 1s\", ());\n\
      \    };\n\
      \n\
      \  <div style> children </div>;\n\
      };\n\
      "
      )        
     ]);
     File("ExampleStyles.re",
     "let reasonReactBlue = \"#48a9dc\";\n\
     \n\
     // The {j|...|j} feature is just string interpolation, from\n\
     // bucklescript.github.io/docs/en/interop-cheatsheet#string-unicode-interpolation\n\
     // This allows us to conveniently write CSS, together with variables, by\n\
     // constructing a string\n\
     let style = {j|\n\
     \  body {\n\
     \    background-color: rgb(224, 226, 229);\n\
     \    display: flex;\n\
     \    flex-direction: column;\n\
     \    align-items: center;\n\
     \  }\n\
     \  button {\n\
     \    background-color: white;\n\
     \    color: $reasonReactBlue;\n\
     \    box-shadow: 0 0 0 1px $reasonReactBlue;\n\
     \    border: none;\n\
     \    padding: 8px;\n\
     \    font-size: 16px;\n\
     \  }\n\
     \  button:active {\n\
     \    background-color: $reasonReactBlue;\n\
     \    color: white;\n\
     \  }\n\
     \  .container {\n\
     \    margin: 12px 0px;\n\
     \    box-shadow: 0px 4px 16px rgb(200, 200, 200);\n\
     \    width: 720px;\n\
     \    border-radius: 12px;\n\
     \    font-family: sans-serif;\n\
     \  }\n\
     \  .containerTitle {\n\
     \    background-color: rgb(242, 243, 245);\n\
     \    border-radius: 12px 12px 0px 0px;\n\
     \    padding: 12px;\n\
     \    font-weight: bold;\n\
     \  }\n\
     \  .containerContent {\n\
     \    background-color: white;\n\
     \    padding: 16px;\n\
     \    border-radius: 0px 0px 12px 12px;\n\
     \  }\n\
     |j};\n\
     "
     );
     Dir("FetchedDogPictures",[
      File("FetchedDogPictures.re",
      "[@bs.val] external fetch: string => Js.Promise.t('a) = \"fetch\";\n\
      \n\
      type state =\n\
      \  | LoadingDogs\n\
      \  | ErrorFetchingDogs\n\
      \  | LoadedDogs(array(string));\n\
      \n\
      [@react.component]\n\
      let make = () => {\n\
      \  let (state, setState) = React.useState(() => LoadingDogs);\n\
      \n\
      \  // Notice that instead of `useEffect`, we have `useEffect0`. See\n\
      \  // reasonml.github.io/reason-react/docs/en/components#hooks for more info\n\
      \  React.useEffect0(() => {\n\
      \    Js.Promise.(\n\
      \      fetch(\"https://dog.ceo/api/breeds/image/random/3\")\n\
      \      |> then_(response => response##json())\n\
      \      |> then_(jsonResponse => {\n\
      \           setState(_previousState => LoadedDogs(jsonResponse##message));\n\
      \           Js.Promise.resolve();\n\
      \         })\n\
      \      |> catch(_err => {\n\
      \           setState(_previousState => ErrorFetchingDogs);\n\
      \           Js.Promise.resolve();\n\
      \         })\n\
      \      |> ignore\n\
      \    );\n\
      \n\
      \    // Returning None, instead of Some(() => ...), means we don't have any\n\
      \    // cleanup to do before unmounting. That's not 100% true. We should\n\
      \    // technically cancel the promise. Unofortunately, there's currently no\n\
      \    // way to cancel a promise. Promises in general should be way less used\n\
      \    // for React components; but since folks do use them, we provide such an\n\
      \    // example here. In reality, this fetch should just be a plain callback,\n\
      \    // with a cancellation API\n\
      \    None;\n\
      \  });\n\
      \n\
      \  <div\n\
      \    style={ReactDOMRe.Style.make(\n\
      \      ~height=\"120px\",\n\
      \      ~display=\"flex\",\n\
      \      ~alignItems=\"center\",\n\
      \      ~justifyContent=\"center\",\n\
      \      (),\n\
      \    )}>\n\
      \    {switch (state) {\n\
      \     | ErrorFetchingDogs => React.string(\"An error occurred!\")\n\
      \     | LoadingDogs => React.string(\"Loading...\")\n\
      \     | LoadedDogs(dogs) =>\n\
      \       dogs\n\
      \       ->Belt.Array.mapWithIndex((i, dog) => {\n\
      \           let imageStyle =\n\
      \             ReactDOMRe.Style.make(\n\
      \               ~height=\"120px\",\n\
      \               ~width=\"100%\",\n\
      \               ~marginRight=i === Js.Array.length(dogs) - 1 ? \"0px\" : \"8px\",\n\
      \               ~borderRadius=\"8px\",\n\
      \               ~boxShadow=\"0px 4px 16px rgb(200, 200, 200)\",\n\
      \               ~backgroundSize=\"cover\",\n\
      \               ~backgroundImage={j|url($dog)|j},\n\
      \               ~backgroundPosition=\"center\",\n\
      \               (),\n\
      \             );\n\
      \           <div key=dog style=imageStyle />;\n\
      \         })\n\
      \       ->React.array\n\
      \     }}\n\
      \  </div>;\n\
      };\n\
      "
      )        
     ]);
     File("Index.re",
     "// Entry point\n\
     \n\
     [@bs.val] external document: Js.t({..}) = \"document\";\n\
     \n\
     // We're using raw DOM manipulations here, to avoid making you read\n\
     // ReasonReact when you might precisely be trying to learn it for the first\n\
     // time through the examples later.\n\
     let style = document##createElement(\"style\");\n\
     document##head##appendChild(style);\n\
     style##innerHTML #= ExampleStyles.style;\n\
     \n\
     let makeContainer = text => {\n\
     \  let container = document##createElement(\"div\");\n\
     \  container##className #= \"container\";\n\
     \n\
     \  let title = document##createElement(\"div\");\n\
     \  title##className #= \"containerTitle\";\n\
     \  title##innerText #= text;\n\
     \n\
     \  let content = document##createElement(\"div\");\n\
     \  content##className #= \"containerContent\";\n\
     \n\
     \  let () = container##appendChild(title);\n\
     \  let () = container##appendChild(content);\n\
     \  let () = document##body##appendChild(container);\n\
     \n\
     \  content;\n\
     };\n\
     \n\
     // All 4 examples.\n\
     ReactDOMRe.render(\n\
     \  <BlinkingGreeting>\n\
     \    {React.string(\"Hello!\")}\n\
     \  </BlinkingGreeting>,\n\
     \  makeContainer(\"Blinking Greeting\"),\n\
     );\n\
     \n\
     ReactDOMRe.render(\n\
     \  <ReducerFromReactJSDocs />,\n\
     \  makeContainer(\"Reducer From ReactJS Docs\"),\n\
     );\n\
     \n\
     ReactDOMRe.render(\n\
     \  <FetchedDogPictures />,\n\
     \  makeContainer(\"Fetched Dog Pictures\"),\n\
     );\n\
     \n\
     ReactDOMRe.render(\n\
     \  <ReasonUsingJSUsingReason />,\n\
     \  makeContainer(\"Reason Using JS Using Reason\"),\n\
     );\n\
     "
     );
     Dir("ReasonUsingJSUsingReason",[
      File("ReactJSCard.js",
      "// In this Interop example folder, we have:\n\
      // - A ReasonReact component, ReasonReactCard.re\n\
      // - Used by a ReactJS component, ReactJSCard.js (this file)\n\
      // - ReactJSCard.js can be used by ReasonReact, through bindings in ReasonUsingJSUsingReason.re\n\
      // - ReasonUsingJSUsingReason.re is used by Index.re\n\
      \n\
      var ReactDOM = require('react-dom');\n\
      var React = require('react');\n\
      \n\
      var ReasonReactCard = require('./ReasonReactCard.bs').make;\n\
      \n\
      var ReactJSComponent = function() {\n\
      \  let backgroundColor = \"rgba(0, 0, 0, 0.05)\";\n\
      \  let padding = \"12px\";\n\
      \n\
      \  // We're not using JSX here, to avoid folks needing to install the related\n\
      \  // React toolchains just for this example.\n\
      \  // <div style={...}>\n\
      \  //   <div style={...}>This is a ReactJS card</div>\n\
      \  //   <ReasonReactCard style={...} />\n\
      \  // </div>\n\
      \  return React.createElement(\n\
      \    \"div\",\n\
      \    {style: {backgroundColor, padding, borderRadius: \"8px\"}},\n\
      \    React.createElement(\"div\", {style: {marginBottom: \"8px\"}}, \"This is a ReactJS card\"),\n\
      \    React.createElement(ReasonReactCard, {style: {backgroundColor, padding, borderRadius: \"4px\"}}),\n\
      \  )\n\
      };\n\
      ReactJSComponent.displayName = \"MyBanner\";\n\
      \n\
      module.exports = ReactJSComponent;\n\
      "
      );
      File("ReasonReactCard.re",
      "// In this Interop example folder, we have:\n\
      // - A ReasonReact component, ReasonReactCard.re (this file)\n\
      // - Used by a ReactJS component, ReactJSCard.js\n\
      // - ReactJSCard.js can be used by ReasonReact, through bindings in ReasonUsingJSUsingReason.re\n\
      // - ReasonUsingJSUsingReason.re is used by Index.re\n\
      \n\
      [@react.component]\n\
      let make = (~style) => {\n\
      \  <div style> {React.string(\"This is a ReasonReact card\")} </div>;\n\
      };\n\
      "
      );
      File("ReasonUsingJSUsingReason.re",
      "// In this Interop example folder, we have:\n\
      // - A ReasonReact component, ReasonReactCard.re\n\
      // - Used by a ReactJS component, ReactJSCard.js\n\
      // - ReactJSCard.js can be used by ReasonReact, through bindings in ReasonUsingJSUsingReason.re (this file)\n\
      // - ReasonUsingJSUsingReason.re is used by Index.re\n\
      \n\
      // All you need to do to use a ReactJS component in ReasonReact, is to write the lines below!\n\
      // reasonml.github.io/reason-react/docs/en/components#import-from-js\n\
      [@react.component] [@bs.module]\n\
      external make: unit => React.element = \"./ReactJSCard\";\n\
      "
      )        
     ]);
     Dir("ReducerFromReactJSDocs",[
      File("ReducerFromReactJSDocs.re",
      "// This is the ReactJS documentation's useReducer example, directly ported over\n\
      // https://reactjs.org/docs/hooks-reference.html#usereducer\n\
      \n\
      // A little extra we've put, because the ReactJS example has no styling\n\
      let leftButtonStyle = ReactDOMRe.Style.make(~borderRadius=\"4px 0px 0px 4px\", ~width=\"48px\", ());\n\
      let rightButtonStyle = ReactDOMRe.Style.make(~borderRadius=\"0px 4px 4px 0px\", ~width=\"48px\", ());\n\
      let containerStyle = ReactDOMRe.Style.make(~display=\"flex\", ~alignItems=\"center\", ~justifyContent=\"space-between\", ());\n\
      \n\
      // Record and variant need explicit declarations.\n\
      type state = {count: int};\n\
      \n\
      type action =\n\
      \  | Increment\n\
      \  | Decrement;\n\
      \n\
      let initialState = {count: 0};\n\
      \n\
      let reducer = (state, action) => {\n\
      \  switch (action) {\n\
      \  | Increment => {count: state.count + 1}\n\
      \  | Decrement => {count: state.count - 1}\n\
      \  };\n\
      };\n\
      \n\
      [@react.component]\n\
      let make = () => {\n\
      \  let (state, dispatch) = React.useReducer(reducer, initialState);\n\
      \n\
      \  // We can use a fragment here, but we don't, because we want to style the counter\n\
      \  <div style=containerStyle>\n\
      \    <div>\n\
      \      {React.string(\"Count: \")}\n\
      \      {React.string(string_of_int(state.count))}\n\
      \    </div>\n\
      \    <div>\n\
      \      <button style=leftButtonStyle onClick={_event => dispatch(Decrement)}>\n\
      \        {React.string(\"-\")}\n\
      \      </button>\n\
      \      <button style=rightButtonStyle onClick={_event => dispatch(Increment)}>\n\
      \        {React.string(\"+\")}\n\
      \      </button>\n\
      \    </div>\n\
      \  </div>;\n\
      };\n\
      "
      )        
     ])        
    ]);
    File("watcher.js",
    "// This is our simple, robust watcher. It hooks into the ReScript build\n\
    // system to listen for build events.\n\
    // See package.json's `start` script and `./node_modules/.bin/bsb --help`\n\
    \n\
    // Btw, if you change this file and reload the page, your browser cache\n\
    // _might_ not pick up the new version. If you're in Chrome, do Force Reload.\n\
    \n\
    var websocketReloader;\n\
    var LAST_SUCCESS_BUILD_STAMP =\n\
    \  localStorage.getItem(\"LAST_SUCCESS_BUILD_STAMP\") || 0;\n\
    // package.json's `start` script's `bsb -ws _` means it'll pipe build events\n\
    // through a websocket connection to a default port of 9999. This is\n\
    // configurable, e.g. `-ws 5000`\n\
    var webSocketPort = 9999;\n\
    \n\
    function setUpWebSocket() {\n\
    \  if (websocketReloader == null || websocketReloader.readyState !== 1) {\n\
    \    try {\n\
    \      websocketReloader = new WebSocket(\n\
    \        `ws://${window.location.hostname}:${webSocketPort}`\n\
    \      );\n\
    \      websocketReloader.onmessage = (message) => {\n\
    \        var newData = JSON.parse(message.data).LAST_SUCCESS_BUILD_STAMP;\n\
    \        if (newData > LAST_SUCCESS_BUILD_STAMP) {\n\
    \          LAST_SUCCESS_BUILD_STAMP = newData;\n\
    \          localStorage.setItem(\n\
    \            \"LAST_SUCCESS_BUILD_STAMP\",\n\
    \            LAST_SUCCESS_BUILD_STAMP\n\
    \          );\n\
    \          // Refresh the page! This will naturally re-run everything,\n\
    \          // including our moduleserve which will re-resolve all the modules.\n\
    \          // No stable build!\n\
    \          location.reload(true);\n\
    \        }\n\
    \      };\n\
    \    } catch (exn) {\n\
    \      console.error(\n\
    \        \"The watcher tried to connect to web socket, but failed. Here's the message:\"\n\
    \      );\n\
    \      console.error(exn);\n\
    \    }\n\
    \  }\n\
    }\n\
    \n\
    setUpWebSocket();\n\
    setInterval(setUpWebSocket, 2000);\n\
    "
    )        
   ]);
   Dir("react-starter",[
    File(".gitignore",
    ".DS_Store\n\
    .merlin\n\
    .bsb.lock\n\
    npm-debug.log\n\
    /lib/bs/\n\
    /node_modules/\n\
    *.bs.js\n\
    "
    );
    File("README.md",
    "# Reason react starter\n\
    \n\
    ## Run Project\n\
    \n\
    ```sh\n\
    npm install\n\
    npm start\n\
    # in another tab\n\
    npm run server\n\
    ```\n\
    \n\
    View the app in the browser at http://localhost:8000. Running in this environment provides hot reloading and support for routing; just edit and save the file and the browser will automatically refresh.\n\
    \n\
    To use a port other than 8000 set the `PORT` environment variable (`PORT=8080 npm run server`).\n\
    \n\
    ## Build for Production\n\
    \n\
    ```sh\n\
    npm run clean\n\
    npm run build\n\
    npm run webpack:production\n\
    ```\n\
    \n\
    This will replace the development artifact `build/Index.js` for an optimized version as well as copy `src/index.html` into `build/`. You can then deploy the contents of the `build` directory (`index.html` and `Index.js`).\n\
    \n\
    **To enable dead code elimination**, change `bsconfig.json`'s `package-specs` `module` from `\"commonjs\"` to `\"es6\"`. Then re-run the above 2 commands. This will allow Webpack to remove unused code.\n\
    "
    );
    File("bsconfig.json",
    "{\n\
    \  \"name\": \"reason-react-starter\",\n\
    \  \"reason\": {\n\
    \    \"react-jsx\": 3\n\
    \  },\n\
    \  \"sources\": {\n\
    \    \"dir\": \"src\",\n\
    \    \"subdirs\": true\n\
    \  },\n\
    \  \"bsc-flags\": [\"-bs-super-errors\", \"-bs-no-version-header\"],\n\
    \  \"package-specs\": [\n\
    \    {\n\
    \      \"module\": \"commonjs\",\n\
    \      \"in-source\": true\n\
    \    }\n\
    \  ],\n\
    \  \"suffix\": \".bs.js\",\n\
    \  \"namespace\": true,\n\
    \  \"bs-dependencies\": [\"reason-react\"],\n\
    \  \"refmt\": 3\n\
    }\n\
    "
    );
    File("package.json",
    "{\n\
    \  \"name\": \"${rescript:name}\",\n\
    \  \"version\": \"${rescript:proj-version}\",\n\
    \  \"scripts\": {\n\
    \    \"build\": \"bsb -make-world\",\n\
    \    \"start\": \"bsb -make-world -w -ws _ \",\n\
    \    \"clean\": \"bsb -clean-world\",\n\
    \    \"webpack\": \"webpack -w\",\n\
    \    \"webpack:production\": \"NODE_ENV=production webpack\",\n\
    \    \"server\": \"webpack-dev-server\",\n\
    \    \"test\": \"echo \\\"Error: no test specified\\\" && exit 1\"\n\
    \  },\n\
    \  \"keywords\": [\n\
    \    \"ReScript\",\n\
    \    \"ReasonReact\",\n\
    \    \"reason-react\"\n\
    \  ],\n\
    \  \"author\": \"\",\n\
    \  \"license\": \"MIT\",\n\
    \  \"dependencies\": {\n\
    \    \"react\": \"^17.0.1\",\n\
    \    \"react-dom\": \"^17.0.1\",\n\
    \    \"reason-react\": \"^0.9.1\"\n\
    \  },\n\
    \  \"devDependencies\": {\n\
    \    \"${rescript:platform}\": \"^${rescript:bs-version}\",\n\
    \    \"css-loader\": \"^5.0.0\",\n\
    \    \"html-webpack-plugin\": \"^4.5.0\",\n\
    \    \"style-loader\": \"^2.0.0\",\n\
    \    \"webpack\": \"^4.44.2\",\n\
    \    \"webpack-cli\": \"^3.3.12\",\n\
    \    \"webpack-dev-server\": \"^3.11.0\"\n\
    \  }\n\
    }\n\
    "
    );
    Dir("src",[
     File("App.re",
     "type state = {count: int};\n\
     \n\
     type action =\n\
     \  | Increment\n\
     \  | Decrement;\n\
     \n\
     let initialState = {count: 0};\n\
     \n\
     let reducer = (state, action) =>\n\
     \  switch (action) {\n\
     \  | Increment => {count: state.count + 1}\n\
     \  | Decrement => {count: state.count - 1}\n\
     \  };\n\
     \n\
     [@react.component]\n\
     let make = () => {\n\
     \  let (state, dispatch) = React.useReducer(reducer, initialState);\n\
     \n\
     \  <main>\n\
     \    {React.string(\"Simple counter with reducer\")}\n\
     \    <div>\n\
     \      <button onClick={_ => dispatch(Decrement)}>\n\
     \        {React.string(\"Decrement\")}\n\
     \      </button>\n\
     \      <span className=\"counter\">\n\
     \        {state.count |> string_of_int |> React.string}\n\
     \      </span>\n\
     \      <button onClick={_ => dispatch(Increment)}>\n\
     \        {React.string(\"Increment\")}\n\
     \      </button>\n\
     \    </div>\n\
     \  </main>;\n\
     };\n\
     "
     );
     File("Index.re",
     "[%bs.raw {|require(\"./index.css\")|}];\n\
     \n\
     ReactDOMRe.renderToElementWithId(<App />, \"root\");\n\
     "
     );
     File("index.css",
     "body {\n\
     \  margin: 0;\n\
     \  font-family: -apple-system, system-ui, \"Segoe UI\", Helvetica, Arial,\n\
     \    sans-serif, \"Apple Color Emoji\", \"Segoe UI Emoji\", \"Segoe UI Symbol\";\n\
     }\n\
     \n\
     main {\n\
     \  padding: 20px;\n\
     }\n\
     \n\
     .counter {\n\
     \  padding: 20px;\n\
     \  display: inline-block;\n\
     }\n\
     "
     );
     File("index.html",
     "<!DOCTYPE html>\n\
     <html lang=\"en\">\n\
     \  <head>\n\
     \    <meta charset=\"UTF-8\" />\n\
     \    <title>Reason react starter</title>\n\
     \  </head>\n\
     \  <body>\n\
     \    <div id=\"root\"></div>\n\
     \    <script src=\"/Index.js\"></script>\n\
     \  </body>\n\
     </html>\n\
     "
     )        
    ]);
    File("webpack.config.js",
    "const path = require(\"path\")\n\
    const HtmlWebpackPlugin = require(\"html-webpack-plugin\")\n\
    const outputDir = path.join(__dirname, \"build/\")\n\
    \n\
    const isProd = process.env.NODE_ENV === \"production\"\n\
    \n\
    module.exports = {\n\
    \  entry: \"./src/Index.bs.js\",\n\
    \  mode: isProd ? \"production\" : \"development\",\n\
    \  devtool: \"source-map\",\n\
    \  output: {\n\
    \    path: outputDir,\n\
    \    filename: \"Index.js\"\n\
    \  },\n\
    \  plugins: [\n\
    \    new HtmlWebpackPlugin({\n\
    \      template: \"src/index.html\",\n\
    \      inject: false\n\
    \    })\n\
    \  ],\n\
    \  devServer: {\n\
    \    compress: true,\n\
    \    contentBase: outputDir,\n\
    \    port: process.env.PORT || 8000,\n\
    \    historyApiFallback: true\n\
    \  },\n\
    \  module: {\n\
    \    rules: [\n\
    \      {\n\
    \        test: /\\.css$/,\n\
    \        use: [\"style-loader\", \"css-loader\"]\n\
    \      }\n\
    \    ]\n\
    \  }\n\
    }\n\
    "
    )        
   ]);
   Dir("tea",[
    File("README.md",
    "\n\
    \n\
    # Build\n\
    ```\n\
    npm run build\n\
    ```\n\
    \n\
    # Watch\n\
    \n\
    ```\n\
    npm run watch\n\
    ```\n\
    \n\
    create a http-server\n\
    \n\
    ```\n\
    npm install -g http-server\n\
    ```\n\
    \n\
    Edit the file and see the changes automatically reloaded in the browser\n\
    "
    );
    File("bsconfig.json",
    "{\n\
    \  \"name\": \"tea\",\n\
    \  \"version\": \"0.1.0\",\n\
    \  \"sources\": {\n\
    \    \"dir\" : \"src\",\n\
    \    \"subdirs\" : true\n\
    \  },\n\
    \  \"package-specs\": {\n\
    \    \"module\": \"commonjs\",\n\
    \    \"in-source\": true\n\
    \  },\n\
    \  \"suffix\": \".bs.js\",\n\
    \  \"bs-dependencies\": [\n\
    \      \"bucklescript-tea\"\n\
    \  ]\n\
    }\n\
    "
    );
    File("index.html",
    "<!DOCTYPE html>\n\
    <html lang=\"en\">\n\
    \  <head>\n\
    \    <meta charset=\"utf-8\">\n\
    \    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n\
    \    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n\
    \    <meta name=\"description\" content=\"\">\n\
    \    <meta name=\"author\" content=\"\">\n\
    \    <title>Bucklescript TEA Starter Kit</title>\n\
    \  </head>\n\
    \  \n\
    \n\
    \n\
    \  <body>\n\
    \    <div id=\"my-element\"> </div>\n\
    \    <script src=\"./loader.js\" type=\"module\" data-main=\"./src/main.bs.js\"></script>\n\
    \    <script src=\"./watcher.js\" type=\"module\"></script>\n\
    \    \n\
    \  </body>\n\
    </html>"
    );
    File("loader.js",
    "/* Copyright (C) 2018 Authors of ReScript\n\
    \ *\n\
    \ * This program is free software: you can redistribute it and/or modify\n\
    \ * it under the terms of the GNU Lesser General Public License as published by\n\
    \ * the Free Software Foundation, either version 3 of the License, or\n\
    \ * (at your option) any later version.\n\
    \ *\n\
    \ * In addition to the permissions granted to you by the LGPL, you may combine\n\
    \ * or link a \"work that uses the Library\" with a publicly distributed version\n\
    \ * of this file to produce a combined library or application, then distribute\n\
    \ * that combined work under the terms of your choosing, with no requirement\n\
    \ * to comply with the obligations normally placed on you by section 4 of the\n\
    \ * LGPL version 3 (or the corresponding section of a later version of the LGPL\n\
    \ * should you choose to use a later version).\n\
    \ *\n\
    \ * This program is distributed in the hope that it will be useful,\n\
    \ * but WITHOUT ANY WARRANTY; without even the implied warranty of\n\
    \ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n\
    \ * GNU Lesser General Public License for more details.\n\
    \ *\n\
    \ * You should have received a copy of the GNU Lesser General Public License\n\
    \ * along with this program; if not, write to the Free Software\n\
    \ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. */\n\
    \n\
    //@ts-check\n\
    \n\
    // @ts-ignore\n\
    window.process = { env: { NODE_ENV: \"dev\" } };\n\
    \n\
    // local to getPath\n\
    var relativeElement = document.createElement(\"a\");\n\
    var baseElement = document.createElement(\"base\");\n\
    document.head.appendChild(baseElement);\n\
    \n\
    export function BsGetPath(id, parent) {\n\
    \  var oldPath = baseElement.href;\n\
    \  baseElement.href = parent;\n\
    \  relativeElement.href = id;\n\
    \  var result = relativeElement.href;\n\
    \  baseElement.href = oldPath;\n\
    \  return result;\n\
    }\n\
    /**\n\
    \ *\n\
    \ * Given current link and its parent, return the new link\n\
    \ * @param {string} id\n\
    \ * @param {string} parent\n\
    \ * @return {string}\n\
    \ */\n\
    function getPathWithJsSuffix(id, parent) {\n\
    \  var oldPath = baseElement.href;\n\
    \  baseElement.href = parent;\n\
    \  relativeElement.href = id;\n\
    \  var result = addSuffixJsIfNot(relativeElement.href);\n\
    \  baseElement.href = oldPath;\n\
    \  return result;\n\
    }\n\
    \n\
    /**\n\
    \ *\n\
    \ * @param {string} x\n\
    \ */\n\
    function addSuffixJsIfNot(x) {\n\
    \  if (x.endsWith(\".js\")) {\n\
    \    return x;\n\
    \  } else {\n\
    \    return x + \".js\";\n\
    \  }\n\
    }\n\
    \n\
    var falsePromise = Promise.resolve(false);\n\
    var fetchConfig = { cache: \"no-cache\" };\n\
    // package.json semantics\n\
    // a string to module object\n\
    // from url -> module object\n\
    // Modules : Map<string, Promise < boolean | string >\n\
    // fetch the link:\n\
    // - if it is already fetched before, return the stored promise\n\
    //   otherwise create the promise which will be filled with the text if successful\n\
    //   or filled with boolean false when failed\n\
    var MODULES = new Map();\n\
    function cachedFetch(link) {\n\
    \  // console.info(link)\n\
    \  var linkResult = MODULES.get(link);\n\
    \  if (linkResult) {\n\
    \    return linkResult;\n\
    \  } else {\n\
    \    var p = fetch(link, fetchConfig).then((resp) => {\n\
    \      if (resp.ok) {\n\
    \        return resp.text();\n\
    \      } else {\n\
    \        return falsePromise;\n\
    \      }\n\
    \    });\n\
    \n\
    \    MODULES.set(link, p);\n\
    \    return p;\n\
    \  }\n\
    }\n\
    \n\
    // from location id -> url\n\
    // There are two rounds of caching:\n\
    // 1. if location and relative path is hit, no need to run\n\
    // 2. if location and relative path is not hit, but the resolved link is hit, no need\n\
    //     for network request\n\
    /**\n\
    \ * @type {Map<string, Map<string, Promise<any> > > }\n\
    \ */\n\
    var IDLocations = new Map();\n\
    \n\
    /**\n\
    \ * @type {Map<string, Map<string, any> > }\n\
    \ */\n\
    var SyncedIDLocations = new Map();\n\
    // Its value is an object\n\
    // { link : String }\n\
    // We will first mark it when visiting (to avoid duplicated computation)\n\
    // and populate its link later\n\
    \n\
    /**\n\
    \ *\n\
    \ * @param {string} id\n\
    \ * @param {string} location\n\
    \ */\n\
    function getIdLocation(id, location) {\n\
    \  var idMap = IDLocations.get(location);\n\
    \  if (idMap) {\n\
    \    return idMap.get(id);\n\
    \  }\n\
    }\n\
    \n\
    /**\n\
    \ *\n\
    \ * @param {string} id\n\
    \ * @param {string} location\n\
    \ */\n\
    function getIdLocationSync(id, location) {\n\
    \  var idMap = SyncedIDLocations.get(location);\n\
    \  if (idMap) {\n\
    \    return idMap.get(id);\n\
    \  }\n\
    }\n\
    \n\
    function countIDLocations() {\n\
    \  var count = 0;\n\
    \  for (let [k, vv] of IDLocations) {\n\
    \    for (let [kv, v] of vv) {\n\
    \      count += 1;\n\
    \    }\n\
    \  }\n\
    \  console.log(count, \"modules loaded\");\n\
    }\n\
    \n\
    /**\n\
    \ *\n\
    \ * @param {string} id\n\
    \ * @param {string} location\n\
    \ * @param {Function} cb\n\
    \ * @returns Promise<any>\n\
    \ */\n\
    function visitIdLocation(id, location, cb) {\n\
    \  var result;\n\
    \  var idMap = IDLocations.get(location);\n\
    \  if (idMap && (result = idMap.get(id))) {\n\
    \    return result;\n\
    \  } else {\n\
    \    result = new Promise((resolve) => {\n\
    \      return cb().then((res) => {\n\
    \        var idMap = SyncedIDLocations.get(location);\n\
    \        if (idMap) {\n\
    \          idMap.set(id, res);\n\
    \        } else {\n\
    \          SyncedIDLocations.set(location, new Map([[id, res]]));\n\
    \        }\n\
    \        return resolve(res);\n\
    \      });\n\
    \    });\n\
    \    if (idMap) {\n\
    \      idMap.set(id, result);\n\
    \    } else {\n\
    \      IDLocations.set(location, new Map([[id, result]]));\n\
    \    }\n\
    \    return result;\n\
    \  }\n\
    }\n\
    \n\
    /**\n\
    \ *\n\
    \ * @param {string} text\n\
    \ * @return {string[]}\n\
    \ */\n\
    function getDeps(text) {\n\
    \  var deps = [];\n\
    \  text.replace(\n\
    \    /(\\/\\*[\\w\\W]*?\\*\\/|\\/\\/[^\\n]*|[.$]r)|\\brequire\\s*\\(\\s*[\"']([^\"']*)[\"']\\s*\\)/g,\n\
    \    function (_, ignore, id) {\n\
    \      if (!ignore) deps.push(id);\n\
    \    }\n\
    \  );\n\
    \  return deps;\n\
    }\n\
    \n\
    // By using a named \"eval\" most browsers will execute in the global scope.\n\
    // http://www.davidflanagan.com/2010/12/global-eval-in.html\n\
    var globalEval = eval;\n\
    \n\
    // function parentURL(url) {\n\
    //     if (url.endsWith('/')) {\n\
    //         return url + '../'\n\
    //     } else {\n\
    //         return url + '/../'\n\
    //     }\n\
    // }\n\
    \n\
    // loader.js:23 http://localhost:8080/node_modules/react-dom/cjs/react-dom.development.js/..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//../ fbjs/lib/containsNode Promise {<pending>}\n\
    // 23:10:02.884 loader.js:23 http://localhost:8080/node_modules/react-dom/cjs/react-dom.development.js/..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//..//../ fbjs/lib/invariant Promise {<pending>}\n\
    \n\
    /**\n\
    \ *\n\
    \ * @param {string} id\n\
    \ * @param {string} parent\n\
    \ */\n\
    function getParentModulePromise(id, parent) {\n\
    \  var parentLink = BsGetPath(\"..\", parent);\n\
    \  if (parentLink === parent) {\n\
    \    return falsePromise;\n\
    \  }\n\
    \  return getPackageJsPromise(id, parentLink);\n\
    }\n\
    // In the beginning\n\
    // it is `resolveModule('./main.js', '')\n\
    // return the promise of link and text\n\
    \n\
    /**\n\
    \ *\n\
    \ * @param {string} id\n\
    \ */\n\
    function getPackageName(id) {\n\
    \  var index = id.indexOf(\"/\");\n\
    \  if (id[0] === \"@\") index = id.indexOf(\"/\", index + 1);\n\
    \  if (index === -1) {\n\
    \    return id;\n\
    \  }\n\
    \  return id.substring(0, index);\n\
    }\n\
    \n\
    /**\n\
    \ *\n\
    \ * @param {string} s\n\
    \ * @param {string} text\n\
    \ * @returns {undefined | string }\n\
    \ */\n\
    function isJustAPackageAndHasMainField(s, text) {\n\
    \  if (s.indexOf(\"/\") >= 0) {\n\
    \    return;\n\
    \  } else {\n\
    \    var mainField;\n\
    \    try {\n\
    \      mainField = JSON.parse(text).main;\n\
    \    } catch (_) {}\n\
    \    if (mainField === undefined) {\n\
    \      return;\n\
    \    } else {\n\
    \      return mainField;\n\
    \    }\n\
    \  }\n\
    }\n\
    function getPackageJsPromise(id, parent) {\n\
    \  var idNodeModulesPrefix = \"./node_modules/\" + id;\n\
    \  var link = getPathWithJsSuffix(idNodeModulesPrefix, parent);\n\
    \  if (parent.endsWith(\"node_modules/\")) {\n\
    \    // impossible that `node_modules/node_modules/xx/x\n\
    \    // return falsePromise\n\
    \    return getParentModulePromise(id, parent);\n\
    \  }\n\
    \n\
    \  var packageJson = BsGetPath(\n\
    \    `./node_modules/${getPackageName(id)}/package.json`,\n\
    \    parent\n\
    \  );\n\
    \n\
    \  return cachedFetch(packageJson).then(function (text) {\n\
    \    if (text !== false) {\n\
    \      var mainField;\n\
    \      if ((mainField = isJustAPackageAndHasMainField(id, text)) !== undefined) {\n\
    \        var packageLink = BsGetPath(\n\
    \          addSuffixJsIfNot(`./node_modules/${id}/${mainField}`),\n\
    \          parent\n\
    \        );\n\
    \        return cachedFetch(packageLink).then(function (text) {\n\
    \          if (text !== false) {\n\
    \            return { text, link: packageLink };\n\
    \          } else {\n\
    \            return getParentModulePromise(id, parent);\n\
    \          }\n\
    \        });\n\
    \      } else {\n\
    \        // package indeed exist\n\
    \        return cachedFetch(link).then(function (text) {\n\
    \          if (text !== false) {\n\
    \            return { text, link };\n\
    \          } else if (!id.endsWith(\".js\")) {\n\
    \            var linkNew = getPathWithJsSuffix(\n\
    \              idNodeModulesPrefix + `/index.js`,\n\
    \              parent\n\
    \            );\n\
    \            return cachedFetch(linkNew).then(function (text) {\n\
    \              if (text !== false) {\n\
    \                return { text, link: linkNew };\n\
    \              } else {\n\
    \                return getParentModulePromise(id, parent);\n\
    \              }\n\
    \            });\n\
    \          } else {\n\
    \            return getParentModulePromise(id, parent);\n\
    \          }\n\
    \        });\n\
    \      }\n\
    \    } else {\n\
    \      return getParentModulePromise(id, parent);\n\
    \    }\n\
    \  });\n\
    }\n\
    \n\
    /**\n\
    \ *\n\
    \ * @param {string} id\n\
    \ * @param {string} parent\n\
    \ * can return Promise <boolean | object>, false means\n\
    \ * this module can not be resolved\n\
    \ */\n\
    function getModulePromise(id, parent) {\n\
    \  var done = getIdLocation(id, parent);\n\
    \  if (!done) {\n\
    \    return visitIdLocation(id, parent, function () {\n\
    \      if (id[0] != \".\") {\n\
    \        // package path\n\
    \        return getPackageJsPromise(id, parent);\n\
    \      } else {\n\
    \        // relative path, one shot resolve\n\
    \        let link = getPathWithJsSuffix(id, parent);\n\
    \        return cachedFetch(link).then(function (text) {\n\
    \          if (text !== false) {\n\
    \            return { text, link };\n\
    \          } else if (!id.endsWith(\".js\")) {\n\
    \            // could be \"./dir\"\n\
    \            var newLink = getPathWithJsSuffix(id + \"/index.js\", parent);\n\
    \            return cachedFetch(newLink).then(function (text) {\n\
    \              if (text !== false) {\n\
    \                return { text, link: newLink };\n\
    \              } else {\n\
    \                throw new Error(` ${id} : ${parent} could not be resolved`);\n\
    \              }\n\
    \            });\n\
    \          } else {\n\
    \            throw new Error(` ${id} : ${parent} could not be resolved`);\n\
    \          }\n\
    \        });\n\
    \      }\n\
    \    });\n\
    \  } else {\n\
    \    return done;\n\
    \  }\n\
    }\n\
    \n\
    /**\n\
    \ *\n\
    \ * @param {string} id\n\
    \ * @param {string} parent\n\
    \ * @returns {Promise<any>}\n\
    \ */\n\
    function getAll(id, parent) {\n\
    \  return getModulePromise(id, parent).then(function (obj) {\n\
    \    if (obj) {\n\
    \      var deps = getDeps(obj.text);\n\
    \      return Promise.all(deps.map((x) => getAll(x, obj.link)));\n\
    \    } else {\n\
    \      throw new Error(`${id}@${parent} was not resolved successfully`);\n\
    \    }\n\
    \  });\n\
    }\n\
    \n\
    /**\n\
    \ *\n\
    \ * @param {string} text\n\
    \ * @param {string} parent\n\
    \ * @returns {Promise<any>}\n\
    \ */\n\
    function getAllFromText(text, parent) {\n\
    \  var deps = getDeps(text);\n\
    \  return Promise.all(deps.map((x) => getAll(x, parent)));\n\
    }\n\
    \n\
    var evaluatedModules = new Map();\n\
    \n\
    function loadSync(id, parent) {\n\
    \  var baseOrModule = getIdLocationSync(id, parent);\n\
    \  if (baseOrModule && baseOrModule.link !== undefined) {\n\
    \    if (evaluatedModules.has(baseOrModule.link)) {\n\
    \      return evaluatedModules.get(baseOrModule.link).exports;\n\
    \    }\n\
    \    if (!baseOrModule.exports) {\n\
    \      baseOrModule.exports = {};\n\
    \      globalEval(\n\
    \        `(function(require,exports,module){${baseOrModule.text}\\n})//# sourceURL=${baseOrModule.link}`\n\
    \      )(\n\
    \        function require(id) {\n\
    \          return loadSync(id, baseOrModule.link);\n\
    \        }, // require\n\
    \        (baseOrModule.exports = {}), // exports\n\
    \        baseOrModule // module\n\
    \      );\n\
    \    }\n\
    \    if (!evaluatedModules.has(baseOrModule.link)) {\n\
    \      evaluatedModules.set(baseOrModule.link, baseOrModule);\n\
    \    }\n\
    \    return baseOrModule.exports;\n\
    \  } else {\n\
    \    throw new Error(`${id} : ${parent} could not be resolved`);\n\
    \  }\n\
    }\n\
    \n\
    function genEvalName() {\n\
    \  return \"eval-\" + (\"\" + Math.random()).substr(2, 5);\n\
    }\n\
    /**\n\
    \ *\n\
    \ * @param {string} text\n\
    \ * @param {string} link\n\
    \ * In this case [text] evaluated result will not be cached\n\
    \ */\n\
    function loadTextSync(text, link) {\n\
    \  var baseOrModule = { exports: {}, text, link };\n\
    \  globalEval(\n\
    \    `(function(require,exports,module){${baseOrModule.text}\\n})//# sourceURL=${\n\
    \      baseOrModule.link\n\
    \    }/${genEvalName()}.js`\n\
    \  )(\n\
    \    function require(id) {\n\
    \      return loadSync(id, baseOrModule.link);\n\
    \    }, // require\n\
    \    baseOrModule.exports, // exports\n\
    \    baseOrModule // module\n\
    \  );\n\
    \  return baseOrModule.exports;\n\
    }\n\
    \n\
    /**\n\
    \ *\n\
    \ * @param {string} text\n\
    \ */\n\
    function BSloadText(text) {\n\
    \  console.time(\"Loading\");\n\
    \  var parent = BsGetPath(\".\", document.baseURI);\n\
    \  return getAllFromText(text, parent).then(function () {\n\
    \    var result = loadTextSync(text, parent);\n\
    \    console.timeEnd(\"Loading\");\n\
    \    return result;\n\
    \  });\n\
    }\n\
    \n\
    function load(id, parent) {\n\
    \  return getAll(id, parent).then(function () {\n\
    \    return loadSync(id, parent);\n\
    \  });\n\
    }\n\
    \n\
    export function BSload(id) {\n\
    \  var parent = BsGetPath(\".\", document.baseURI);\n\
    \  return load(id, parent);\n\
    }\n\
    \n\
    export var BSLoader = {\n\
    \  loadText: BSloadText,\n\
    \  load: BSload,\n\
    \  SyncedIDLocations: SyncedIDLocations,\n\
    };\n\
    \n\
    window.BSLoader = BSLoader;\n\
    \n\
    var main = document.querySelector(\"script[data-main]\");\n\
    if (main) {\n\
    \  BSload(main.dataset.main);\n\
    }\n\
    "
    );
    File("package.json",
    "{\n\
    \  \"name\": \"${rescript:name}\",\n\
    \  \"version\": \"${rescript:proj-version}\",\n\
    \  \"scripts\": {\n\
    \    \"clean\": \"bsb -clean-world\",\n\
    \    \"build\": \"bsb -make-world\",\n\
    \    \"watch\": \"bsb -make-world -w -ws _\"\n\
    \  },\n\
    \  \"keywords\": [\n\
    \    \"ReScript\"\n\
    \  ],\n\
    \  \"author\": \"\",\n\
    \  \"license\": \"MIT\",\n\
    \  \"devDependencies\": {\n\
    \    \"${rescript:platform}\": \"^${rescript:bs-version}\"\n\
    \  },\n\
    \  \"dependencies\": {\n\
    \    \"bucklescript-tea\": \"^0.7.4\"\n\
    \  }\n\
    }\n\
    "
    );
    Dir("src",[
     File("demo.ml",
     "(* This line opens the Tea.App modules into the current scope for Program access functions and types *)\n\
     open Tea.App\n\
     \n\
     (* This opens the Elm-style virtual-dom functions and types into the current scope *)\n\
     open Tea.Html\n\
     \n\
     (* Let's create a new type here to be our main message type that is passed around *)\n\
     type msg =\n\
     \  | Increment  (* This will be our message to increment the counter *)\n\
     \  | Decrement  (* This will be our message to decrement the counter *)\n\
     \  | Reset      (* This will be our message to reset the counter to 0 *)\n\
     \  | Set of int (* This will be our message to set the counter to a specific value *)\n\
     \  [@@bs.deriving {accessors}] (* This is a nice quality-of-life addon from Bucklescript, it will generate function names for each constructor name, optional, but nice to cut down on code, this is unused in this example but good to have regardless *)\n\
     \n\
     (* This is optional for such a simple example, but it is good to have an `init` function to define your initial model default values, the model for Counter is just an integer *)\n\
     let init () = 4\n\
     \n\
     (* This is the central message handler, it takes the model as the first argument *)\n\
     let update model = function (* These should be simple enough to be self-explanatory, mutate the model based on the message, easy to read and follow *)\n\
     \  | Increment -> model + 1\n\
     \  | Decrement -> model - 1\n\
     \  | Reset -> 0\n\
     \  | Set v -> v\n\
     \n\
     (* This is just a helper function for the view, a simple function that returns a button based on some argument *)\n\
     let view_button title msg =\n\
     \  button\n\
     \    [ onClick msg\n\
     \    ]\n\
     \    [ text title\n\
     \    ]\n\
     \n\
     (* This is the main callback to generate the virtual-dom.\n\
     \  This returns a virtual-dom node that becomes the view, only changes from call-to-call are set on the real DOM for efficiency, this is also only called once per frame even with many messages sent in within that frame, otherwise does nothing *)\n\
     let view model =\n\
     \  div\n\
     \    []\n\
     \    [ span\n\
     \        [ style \"text-weight\" \"bold\" ]\n\
     \        [ text (string_of_int model) ]\n\
     \    ; br []\n\
     \    ; view_button \"Increment\" Increment\n\
     \    ; br []\n\
     \    ; view_button \"Decrement\" Decrement\n\
     \    ; br []\n\
     \    ; view_button \"Set to 2\" (Set 42)\n\
     \    ; br []\n\
     \    ; if model <> 0 then view_button \"Reset\" Reset else noNode\n\
     \    ]\n\
     \n\
     (* This is the main function, it can be named anything you want but `main` is traditional.\n\
     \  The Program returned here has a set of callbacks that can easily be called from\n\
     \  Bucklescript or from javascript for running this main attached to an element,\n\
     \  or even to pass a message into the event loop.  You can even expose the\n\
     \  constructors to the messages to javascript via the above [@@bs.deriving {accessors}]\n\
     \  attribute on the `msg` type or manually, that way even javascript can use it safely. *)\n\
     let main =\n\
     \  beginnerProgram { (* The beginnerProgram just takes a set model state and the update and view functions *)\n\
     \    model = init (); (* Since model is a set value here, we call our init function to generate that value *)\n\
     \    update;\n\
     \    view;\n\
     \  }"
     );
     File("main.ml",
     "\n\
     \n\
     \n\
     Js.Global.setTimeout\n\
     \  (fun _ -> \n\
     \  Demo.main (Web.Document.getElementById \"my-element\") () \n\
     \  |. ignore\n\
     \  )  \n\
     0"
     )        
    ]);
    File("watcher.js",
    "\n\
    \n\
    var wsReloader;\n\
    var LAST_SUCCESS_BUILD_STAMP = (localStorage.getItem('LAST_SUCCESS_BUILD_STAMP') || 0)\n\
    var WS_PORT = 9999; // configurable\n\
    \n\
    function setUpWebScoket() {\n\
    \    if (wsReloader == null || wsReloader.readyState !== 1) {\n\
    \        try {\n\
    \            wsReloader = new WebSocket(`ws://${window.location.hostname}:${WS_PORT}`)\n\
    \            wsReloader.onmessage = (msg) => {\n\
    \                var newData = JSON.parse(msg.data).LAST_SUCCESS_BUILD_STAMP\n\
    \                if (newData > LAST_SUCCESS_BUILD_STAMP) {\n\
    \                    LAST_SUCCESS_BUILD_STAMP = newData\n\
    \                    localStorage.setItem('LAST_SUCCESS_BUILD_STAMP', LAST_SUCCESS_BUILD_STAMP)\n\
    \                    location.reload(true)\n\
    \                }\n\
    \n\
    \            }\n\
    \        } catch (exn) {\n\
    \            console.error(\"web socket failed connect\")\n\
    \        }\n\
    \    }\n\
    };\n\
    \n\
    setUpWebScoket();\n\
    setInterval(setUpWebScoket, 2000);"
    )        
   ])
])