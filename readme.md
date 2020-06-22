
# Source code for Svelte Tutorials at MDN Web docs

Source code of the To-Do list app for the Svelte tutorials at [Understanding client-side JavaScript frameworks](Understanding client-side JavaScript frameworks) series at MDN Web docs.

Each article has it's correspondent folder with the source code to follow the tutorial

To get the source files you have to clone the repository, like this:

```shell
git clone https://github.com/opensas/mdn-svelte-todo.git
```

> Note: If you just want to download the files without cloning the git repo, you can use the [degit](https://github.com/Rich-Harris/degit) tool like this `npx degit opensas/mdn-svelte-todo`. You can also download a specific folder with `npx degit opensas/mdn-svelte-todo/01-getting-started`.

Then to get the app running, cd into the article's folder, install dependencies and start the app in development mode, like this:

mode for each article just run the following:

```
cd 01-getting-started
npm install
npm run dev
```

We also provide a Svelte REPL for each article, as listed below, so that you can just start coding online without having to install anything on your desktop.

## 01. Getting started with Svelte

In this article we'll provide a quick introduction to Svelte. We will see how Svelte works and what sets it apart from the rest of the frameworks and tools we've seen so far. Then we will learn how to setup our development environment, create a sample app, understand the structure of the project, and see how to run the project locally and build it for production.

You can see the complete content of this article [here](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_getting_started).

You can also play with an online version of this app in this Svelte [REPL](https://svelte.dev/repl/fc68b4f059d34b9c84fa042d1cce586c?version=3.23.2).

## 02. Starting our To-Do list app

In this section we will first have a look at the desired functionality of our app, then we'll create our `Todos.svelte` component and put static markup and styles in place, leaving everything ready to start developing our To-Do list app features, which we'll go on to in the next article. 

You can see the complete content of this article [here](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_starting_our_todo_app).

You can also play with an online version of this app in this Svelte [REPL](https://svelte.dev/repl/b7b831ea3a354d3789cefbc31e2ca495?version=3.23.2).

## 03. Adding dynamic behavior: working with variables and props

Now that we have our markup and styles ready we can start developing the required features for our To-Do list app. In this article we'll be using variables and props to make our app dynamic, allowing us to add and delete todos, and mark them as complete. 

You can see the complete content of this article [here](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_adding_dynamic_behavior).

You can also play with an online version of this app in this Svelte [REPL](https://svelte.dev/repl/c862d964d48d473ca63ab91709a0a5a0?version=3.23.2).
