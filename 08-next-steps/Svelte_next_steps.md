# Deployment, TypeScript support and next Steps

In the last article we learned about Svelte stores and even implemented our own custom store to persist our app's information to Web Storage. We also had a look at using the `transition` directive to implement animations on DOM elements.

That was the last step to finally complete our fully working Svelte app. We put all of the essential Svelte concepts into practice, and even had a look at a few advanced topics. 

Now is the time to learn how to compile and deploy our app to production. 

We will also see how to enable Svelte TypeScript support and which resources are available on line to keep learning Svelte.

> **Prerequisites**: Familiarity with the core HTML, CSS, and JavaScript languages, knowledge of the terminal/command line.
> 
> **Objective**: Learn how to prepare our Svelte app for production.

## Coding along with us

If you want to get the app's code as it is at the beginning of this article and start coding along, you can clone the GitHub repo (if you haven't already done it) with `git clone https://github.com/opensas/mdn-svelte-tutorial.git` and then `cd mdn-svelte-tutorial/07-next-steps`. Alternatively, or you can directly download the folder's content with `npx degit opensas/mdn-svelte-tutorial/07-next-steps`. Remember to run `npm install && npm run dev` to start your app in development mode. You can also follow us online using this [REPL](https://svelte.dev/repl/378dd79e0dfe4486a8f10823f3813190?version=3.23.2).

## Compiling our app

So far we've been running our app in development mode with `npm run dev`. As we saw earlier, this instruction tells Svelte to compile our components and Javascript files into a `public/build/bundle.js` file and all the CSS sections of our components into `public/build/bundle.css`. It also starts a development server and watches for changes, recompiling the app and refreshing the page when a change occurs.

These are our generated `bundle.js` and `bundle.css` files:

```
  504 Jul 13 02:43 bundle.css
95981 Jul 13 02:43 bundle.js
```

To compile our application for production we just have to run `npm run build`. In this case, Svelte won't lunch a web server or keep watching for changes. It will however minify and compress our JavaScript files using [terser](https://terser.org/). 

So, after running `npm run build`, our generated `bundle.js` and `bundle.css` files will be like this:

```
  504 Jul 13 02:43 bundle.css
21782 Jul 13 02:43 bundle.js
```

Try running `npm run build` in your app's root directory now. You might get a warning, but you can ignore this for now.

Our whole app is now just 21 KB, 8.3 KB when gzipped. There are no additional runtimes or dependencies to download, parse, execute and keep running in memory. Svelte analyzed our components and compiled the code to vanilla JavaScript. 

## A look behind the Svelte compilation process

By default, when you create a new app with `npx degit sveltejs/template my-svelte-project`, Svelte will use [rollup](https://rollupjs.org) as module bundler.

Note: There is also an official template for using [webpack](https://webpack.js.org/) and also many [community-maintained plugins](https://github.com/sveltejs/integrations#bundler-plugins) for other bundlers. 

In the file `package.json` you can see that the `dev` and `start` scripts are just calling rollup:

```json
  "scripts": {
    "build": "rollup -c",
    "dev": "rollup -c -w",
    "start": "sirv public"
  },
```

In the `dev` script we are passing the `-w` argument, which tells rollup to watch files and rebuild on changes.

If we have a look at the `rollup.config.js` file, we'll see that the Svelte compiler is just a rollup plugin. 

```javascript
import svelte from 'rollup-plugin-svelte';
[...]
import { terser } from 'rollup-plugin-terser';

const production = !process.env.ROLLUP_WATCH;

export default {
  input: 'src/main.js',
  output: {
    sourcemap: true,
    format: 'iife',
    name: 'app',
    file: 'public/build/bundle.js'
  },
  plugins: [
    svelte({
      // enable run-time checks when not in production
      dev: !production,
      // we'll extract any component CSS out into
      // a separate file - better for performance
      css: css => {
        css.write('public/build/bundle.css');
      }
    }),
```

Later on in the same file you'll also see how rollup minimizes our scripts in production mode and launches a local server in development mode.

```javascript
    // In dev mode, call `npm run start` once
    // the bundle has been generated
    !production && serve(),

    // Watch the `public` directory and refresh the
    // browser on changes when not in production
    !production && livereload('public'),

    // If we're building for production (npm run build
    // instead of npm run dev), minify
    production && terser()
  ],
```

There are many plugins for rollup that allow you to customize its behavior. A list of plugins may be found at [https://github.com/rollup/awesome](https://github.com/rollup/awesome). A particularly useful plugin, which is also maintained by the Svelte team, is [svelte-preprocess](https://github.com/sveltejs/svelte-preprocess), which pre-process many different kinds of languages in Svelte files such as PostCSS, SCSS, Less, Coffeescript, SASS, and Typescript.

## Deploying your Svelte application

From the point of view of a web server, a Svelte application is nothing more than a bunch of HTML, CSS, and JavaScript files. All you need is a web server capable of serving static files. That means you have plenty of options to choose from.

> Note: the following section applies not only to Svelte application, but to any server-side static web site requiring a build step.

One of the easiest ways to deploy a Svelte application is using [Vercel](https://vercel.com/home). Vercel is a cloud platform specifically tailored for static sites, which has out-of-the-box support for most common front-end tools, Svelte being one of them.

To deploy our app, follow these steps.

1. [register](https://vercel.com/signup) for an account with Vercel.
2. Navigate to the root of your app and run `npx vercel`; the first time you do it, you'll be prompted to enter your email address, and follow the steps in the email sent to that address, for security purposes.
3. Run `vercel` again, and you'll be prompted to answer a few questions, like this:

```shell
$ npx vercel
Vercel CLI 19.1.2
? Set up and deploy “./mdn-svelte-tutorial”? [Y/n] y
? Which scope do you want to deploy to? opensas
? Link to existing project? [y/N] n
? What’s your project’s name? mdn-svelte-tutorial
? In which directory is your code located? ./
Auto-detected Project Settings (Svelte):
- Build Command: `npm run build` or `rollup -c`
- Output Directory: public
- Development Command: sirv public --single --dev --port $PORT
? Want to override the settings? [y/N] n
   Linked to opensas/mdn-svelte-tutorial (created .vercel)
   Inspect: https://vercel.com/opensas/mdn-svelte-tutorial/[...] [1s]
✅  Production: https://mdn-svelte-tutorial.vercel.app [copied to clipboard] [19s]
   Deployed to production. Run `vercel --prod` to overwrite later (https://vercel.link/2F).
   To change the domain or build command, go to https://zeit.co/opensas/mdn-svelte-tutorial/settings
```

Basically, just accept all the defaults, and you'll be fine. Once it has finished deploying, go to the "Production" URL in your browser, and you'll see the app deployed!

You can also [import a Svelte git project](https://vercel.com/import/svelte) into Vercel from [GitHub](https://github.com/), [GitLab](https://about.gitlab.com/), or [BitBucket](https://bitbucket.org/product).  

> Note: you can globally install Vercel with `npm i -g vercel` so you don't have to use npx to run it.

## Automatic deploy to GitLab Pages

For hosting static files there are several online services that allow you to automatically deploy your site whenever you push changes to a git repository. Most of them involve setting up a deployment pipeline that gets triggered on every git push, and takes care of building and deploying your web site.

To demonstrate this, we will deploy our todos app to [GitLab Pages](https://about.gitlab.com/stages-devops-lifecycle/pages/).

First you'll have to [register at GitLab](https://gitlab.com/users/sign_up) and then [create a new project](https://gitlab.com/projects/new). Give you new project a short, easy name like 'mdn-svelte-todo'. You will have a remote url that points to your new GitLab git repository, like: `git@gitlab.com:[your-user]/[your-project].git`

> Before you start to upload content to your git repository, it is a good practice to add a `.gitignore` file to tell git which files to exclude from source control. In our case we will tell git to exclude files in the node_modules directory by creating a `.gitignore` file in the root folder of your local project, with the following content: 

```
node_modules/
```

Now let's go back to GitLab. After creating a new repo GitLab will greet you with a message explaining different options to upload your existing files. Follow the steps listed under the _Push an existing folder_ title:

```shell
cd your_root_directory # Go into your project's root directory
git init
git remote add origin https://gitlab.com/[your-user]/mdn-svelte-todo.git
git add .
git commit -m "Initial commit"
git push -u origin master
```

> You can also use [the git protocol](https://git-scm.com/book/en/v2/Git-on-the-Server-The-Protocols#_the_git_protocol) which is faster and saves from typing your username and password every time you access your origin repo. To use it you'll have to [create a SSH key pair](https://docs.gitlab.com/ee/ssh/README.html#generating-a-new-ssh-key-pair). Your origin url will be like this: `git@gitlab.com:[your-user]/mdn-svelte-todo.git`. 

With these instructions we initialize a local git repository, then set our remote origin (where we will push our code to) as our repo on GitLab. Next we commit all the files to the local git repo, and then push those to the remote origin on GitLab.

To deploy your site, GitLab uses a built-in tool called [GitLab CI/CD](https://docs.gitlab.com/ee/ci/README.html) to build your site and publish it to the GitLab Pages server. The sequence of scripts that GitLab CI/CD runs to accomplish this task is created from a file named `.gitlab-ci.yml`, which you can create and modify at will. A specific job called pages in the configuration file will make GitLab aware that you are deploying a GitLab Pages website. 

Create the `.gitlab-ci.yml` file inside your project's root with the following content:

```yaml
image: node:latest
pages:
  stage: deploy
  script:
    - npm install
    - npm run build
  artifacts:
    paths:
      - public
  only:
    - master
```

Here we are telling GitLab to use an image with the latest version of node to build our app. Next we are declaring a 'pages' job, to enable GitLab Pages. Whenever there's a push to our repo, GitLab will run `npm install` and `npm run build` to build our application. We are also telling GitLab to deploy the contents of the `public` folder. On the last line, we are configuring GitLab to redeploy our app only when there's a push to our master branch.

Since our app will be published at a subdirectory (like https://your-user.gitlab.io/mdn-svelte-todo), we'll have to make the references to the JavaScript and CSS files in our `public/index.html` file relative. To do this, we just remove the leading slashes (`/`) from the `/global.css`, `/build/bundle.css`, and `/build/bundle.js` URLs, like this:

```html
  <title>Svelte To-Do list</title>

  <link rel='icon' type='image/png' href='favicon.png'>
  <link rel='stylesheet' href='global.css'>
  <link rel='stylesheet' href='build/bundle.css'>

  <script defer src='build/bundle.js'></script>
```

Do this now.

Now we just have to commit and push our changes to GitLab. Do this by running the following commands:

```
$ git add public/index.html
$ git add .gitlab-ci.yml
$ git commit -m "Added .gitlab-ci.yml file and fixed index.html absolute paths"
$ git push
Counting objects: 5, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (5/5), done.
Writing objects: 100% (5/5), 541 bytes | 541.00 KiB/s, done.
Total 5 (delta 3), reused 0 (delta 0)
To gitlab.com:opensas/mdn-svelte-todo.git
   7dac9f3..5725f46  master -> master
```

Whenever there's a job running GitLab will display an icon showing the process of the job. Clicking on it will let you inspect the output of the job.

![GitLab Pages deploy](./images/01-gitlab-pages-deploy.png)

You can also check the progress of the current and previous jobs from the _CI / CD_, _Jobs_ option of your GitLab project.

![GitLab Pages job](./images/02-gitlab-pages-job.png)

Once GitLab finishes building and publishing your app, it will be accessible at https://your-user.gitlab.io/mdn-svelte-todo/, in my case it's https://opensas.gitlab.io/mdn-svelte-todo/. You can check your pages url from GitLab's UI in the _Settings_ -> _Pages_ section. 

With this configuration, whenever you push your changes to the GitLab repo, the application will be automatically rebuilt and deployed to GitLab Pages. 

> You can see a detailed step-by-step explanation of setting up a similar configuration with [GitHub](https://github.com/) and [Netlify](https://www.netlify.com/) in the [Deploying your app](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Understanding_client-side_tools/Deployment#Committing_changes_to_GitHub) article at MDN web docs.

You can also configure a similar workflow to what we did above with GitLab above with [GitHub](https://github.com/), using the [Deploy to GitHub Pages](https://github.com/marketplace/actions/deploy-to-github-pages) action.

## Svelte documentation

To go further and learn more about Svelte, you should definitely visit the [Svelte homepage](https://svelte.dev/). There you'll find [many articles](https://svelte.dev/blog) explaining Svelte's philosophy. If you haven't already done it, make sure you go through the [Svelte interactive tutorial](https://svelte.dev/tutorial/basics). We already covered most of its content, so it won't take you much time to complete it.

You can also consult the [API docs](https://svelte.dev/docs) and the available [examples](https://svelte.dev/examples#hello-world).

To understand the motivations behind Svelte, you should read [Rich Harris's "Rethinking reactivity"](https://www.youtube.com/watch?v=AdNJ3fydeao&t=47s) presentation on YouTube. He is the creator of Svelte, so he has a couple of things to say about it. You also have the interactive slides available [here](https://rethinking-reactivity.surge.sh) which are, unsurprisingly, built with svelte. If you liked it, you will also enjoy [The Return of 'Write Less, Do More'](https://www.youtube.com/watch?v=BzX4aTRPzno) presentation, which Rich Harris gave at [JSCAMP 2019](https://jscamp.tech/2019/).

## Related projects

There are also other projects related to Svelte that are worth checking out:

- [Sapper](https://sapper.svelte.dev/) - An application framework powered by Svelte that provides server-side rendering (SSR), code splitting, file-based routing and offline support, among other features. Think of it as [Next.js](https://nextjs.org/) for Svelte. If you are planning to develop a fairly complex web application you should definitely have a look at this project.

- [Svelte Native](https://svelte-native.technology/) - A mobile application framework powered by Svelte. Think of it as [React Native](https://reactnative.dev/) for Svelte.

- [Svelte for VS Code](https://marketplace.visualstudio.com/items?itemName=svelte.svelte-vscode) - The officially supported VS Code plugin for working with `.svelte` files. 

## Interacting with the community

There are different ways to get support and interact with the Svelte community:

- [svelte.dev/chat](https://svelte.dev/chat) — Svelte's Discord server.

- [@sveltejs](https://twitter.com/sveltejs) — The official Twitter account.

- [@sveltesociety](https://twitter.com/sveltesociety) — Svelte community Twitter account.

- [Svelte Recipes](https://github.com/svelte-society/recipes-mvp#recipes-mvp) - Community-driven repository of recipes, tips, and best practices to solve common problems.

- [Svelte questions as stackoverflow](https://stackoverflow.com/questions/tagged/svelte) - Questions with the `svelte` tag at stackoverflow.

- [Svelte reddit community](https://www.reddit.com/r/sveltejs/) - Svelte community discussion and content rating site at [reddit](https://www.reddit.com/).

- [Svelte DEV community](https://dev.to/t/svelte) - A collection of Svelte-related technical articles and tutorials from the DEV.to community.

## Learning resources

There's a complete course about Svelte and Sapper by [@Rich_Harris](https://twitter.com/Rich_Harris), Svelte's creator, available at [Frontend Masters](https://frontendmasters.com/courses/svelte/).

Even though Svelte is a relatively young project there are lots of tutorials and [courses](https://www.udemy.com/topic/svelte-framework/?sort=popularity) available on the web, so it's difficult to make a recommendation. 

Nevertheless, [Svelte.js - The Complete Guide](https://www.udemy.com/course/sveltejs-the-complete-guide/) by [Academind](https://academind.com/) is a very popular option with great ratings.

The [Svelte Handbook](https://www.freecodecamp.org/news/the-svelte-handbook/), by [Flavio Copes](https://flaviocopes.com/), is also a useful reference for learning the main Svelte concepts.

If you prefer to read books, there's [Svelte and Sapper in Action](https://www.manning.com/books/svelte-and-sapper-in-action) by [Mark Volkman](https://twitter.com/mark_volkmann), expected to be published in September 2020, but which you can already [preview online](https://livebook.manning.com/book/svelte-and-sapper-in-action/welcome/v-5/) for free.

If you want dive deeper and understand the inner working of Svelte's compiler you should check [Tan Li Hau's](https://twitter.com/lihautan) [Compile Svelte in your head](https://lihautan.com/compile-svelte-in-your-head-part-1/) blog posts. Here's [part 1](https://lihautan.com/compile-svelte-in-your-head-part-1/), [part 2](https://lihautan.com/compile-svelte-in-your-head-part-2/) and [part 3](https://lihautan.com/compile-svelte-in-your-head-part-3/).

## Fin

Congratulations! You have completed the Svelte tutorial. In the previous articles we went from zero knowledge about Svelte to building and deploying a complete application. We learned about Svelte philosophy and what sets it apart from other front-end frameworks. We saw how to add dynamic behavior to our web site, how to organize our app in components and different ways to share information among them. We took advantage of the Svelte reactivity system and learned how to avoid common pitfalls. We also saw some advanced concepts and techniques to interact with DOM elements and to programmatically extend HTML element capabilities using the `use` directive. Then we saw how to use stores to work with a central data repository, and we created our own custom store to persist our application's data to Web Storage.

In this article we've learned about a couple of zero-fuss options to deploy our app in production and seen how to setup a basic pipeline to deploy our app to GitLab on every commit. We also had the chance to test drive TypeScript support in Svelte.

Then we provided you with a list of Svelte resources to go further with your Svelte learning.

Congratulations! After completing this tutorial you have a strong base to start developing professional web applications with Svelte.
