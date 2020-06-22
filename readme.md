# Source code for Svelte Tutorials at MDN Web docs

Source code of the To-Do list app for the Svelte tutorials at [Understanding client-side JavaScript frameworks](Understanding client-side JavaScript frameworks) series at MDN Web docs.

Each article has it's correspondent folder with the source code to follow the tutorial

To get the source files you have to clone the repository, like this:

```shell
git clone https://github.com/opensas/mdn-svelte-tutorial.git
```

> Note: If you just want to download the files without cloning the git repo, you can use the [degit](https://github.com/Rich-Harris/degit) tool like this `npx degit opensas/mdn-svelte-tutorial`. You can also download a specific folder with `npx degit opensas/mdn-svelte-tutorial/01-getting-started`.

Then to get the app running, cd into the article's folder, and run the following commands:

```
cd 01-getting-started
npm install
npm run dev
```

We also provide a Svelte REPL for each article, as listed below, so that you can just start coding online without having to install anything on your desktop.

## 01. Getting started with Svelte

In this article we'll provide a quick introduction to Svelte. We will see how Svelte works and what sets it apart from the rest of the frameworks and tools we've seen so far. Then we will learn how to setup our development environment, create a sample app, understand the structure of the project, and see how to run the project locally and build it for production.

You can see the complete content of this article [here](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_getting_started).

The source code is in the `01-getting-started` folder, you can also play with an online version this Svelte [REPL](https://svelte.dev/repl/fc68b4f059d34b9c84fa042d1cce586c?version=3.23.2).

## 02. Starting our To-Do list app

In this section we will first have a look at the desired functionality of our app, then we'll create our `Todos.svelte` component and put static markup and styles in place, leaving everything ready to start developing our To-Do list app features, which we'll go on to in the next article. 

You can see the complete content of this article [here](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_starting_our_todo_app).

The source code is in the `02-starting-our-todo-app` folder, you can also play with an online version this Svelte [REPL](https://svelte.dev/repl/b7b831ea3a354d3789cefbc31e2ca495?version=3.23.2).

## 03. Adding dynamic behavior: working with variables and props

Now that we have our markup and styles ready we can start developing the required features for our To-Do list app. In this article we'll be using variables and props to make our app dynamic, allowing us to add and delete todos, and mark them as complete. 

You can see the complete content of this article [here](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_adding_dynamic_behavior).

The source code is in the `03-adding-dynamic-behavior` folder, you can also play with an online version this Svelte [REPL](https://svelte.dev/repl/c862d964d48d473ca63ab91709a0a5a0?version=3.23.2).

## 04. Componentizing our Svelte app

In the last article we started developing our Todo list app. Now it's time to go further and add more features to our app, but the central objective here is to look at how to break our app into manageable components and share information between them.

You can see the complete content of this article [here](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_componentizing-our-app).

The source code is in the `04-componentizing-our-app` folder, you can also play with an online version this Svelte [REPL](https://svelte.dev/repl/99b9eb228b404a2f8c8959b22c0a40d3?version=3.23.2).
