# Source code for Svelte Tutorials at MDN Web docs

Source code of the To-Do list app for the Svelte tutorials at [Understanding client-side JavaScript frameworks](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks) series at MDN Web docs.

Each article has it's correspondent folder with the source code to follow the tutorial.

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

You can see the complete content of this article [here](./01-getting-started/Svelte_getting_started.md) or at [MDN web docs](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_getting_started).

The source code to follow this article is in the `01-getting-started` folder, you can download it with the `npx degit opensas/mdn-svelte-tutorial/01-getting-started svelte-todo` command. You can also play with an online version using this Svelte [REPL](https://svelte.dev/repl/fc68b4f059d34b9c84fa042d1cce586c?version=3.23.2).

## 02. Starting our To-Do list app

In this section we will first have a look at the desired functionality of our app, then we'll create our `Todos.svelte` component and put static markup and styles in place, leaving everything ready to start developing our To-Do list app features, which we'll go on to in the next article. 

You can see the complete content of this article [here](./02-starting-our-todo-app/Svelte_starting_our_todo_app.md) or at [MDN web docs](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_todo_list_beginning).

The source code to follow this article is in the `02-starting-our-todo-app` folder, you can download it with the `npx degit opensas/mdn-svelte-tutorial/02-starting-our-todo-app svelte-todo` command. You can also play with an online version using this Svelte [REPL](https://svelte.dev/repl/b7b831ea3a354d3789cefbc31e2ca495?version=3.23.2).

## 03. Adding dynamic behavior: working with variables and props

Now that we have our markup and styles ready we can start developing the required features for our To-Do list app. In this article we'll be using variables and props to make our app dynamic, allowing us to add and delete todos, and mark them as complete. 

You can see the complete content of this article [here](./03-adding-dynamic-behavior/Svelte_adding_dynamic_behavior.md) or at [MDN web docs](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_variables_props).

The source code to follow this article is in the `03-adding-dynamic-behavior` folder, you can download it with the `npx degit opensas/mdn-svelte-tutorial/03-adding-dynamic-behavior svelte-todo` command. You can also play with an online version using this Svelte [REPL](https://svelte.dev/repl/c862d964d48d473ca63ab91709a0a5a0?version=3.23.2).

## 04. Componentizing our Svelte app

In the last article we started developing our Todo list app. Now it's time to go further and add more features to our app, but the central objective here is to look at how to break our app into manageable components and share information between them.

You can see the complete content of this article [here](./04-componentizing-our-app/Svelte_componentizing_our_app.md) or at [MDN web docs](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_components).

The source code to follow this article is in the `04-componentizing-our-app` folder, you can download it with the `npx degit opensas/mdn-svelte-tutorial/04-componentizing-our-app svelte-todo` command. You can also play with an online version using this Svelte [REPL](https://svelte.dev/repl/99b9eb228b404a2f8c8959b22c0a40d3?version=3.23.2).

## 05. Svelte advanced concepts

In the last article we added more features to our To-Do list and started to organize our app into components. In this article we will add the app's final features and further componentize our app. We will learn how to deal with reactivity issues related to updating objects and arrays. Then we will focus on some accessibility issues involving focus management. Finally, we will see how components can also expose methods and variables to access them programmatically.

You can see the complete content of this article [here](./05-advanced-concepts/Svelte_advanced_concepts.md) or at [MDN web docs](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_reactivity_lifecycle_accessibility).

The source code to follow this article is in the `05-advanced-concepts` folder, you can download it with the `npx degit opensas/mdn-svelte-tutorial/05-advanced-concepts svelte-todo` command. You can also play with an online version using this Svelte [REPL](https://svelte.dev/repl/76cc90c43a37452e8c7f70521f88b698?version=3.23.2).

## 06. Working with Svelte stores

In the last article we completed the development of our app, organized it into components, and saw a couple of advanced techniques for dealing with reactivity, working with DOM nodes and exposing components functionality. In this case we will have a look at Svelte stores: a global data repository that holds value and that allows you to subscribe to it and get notified when the value changes. We will also see how to develop our own custom store to persist the todos information to local storage.

You can see the complete content of this article [here](./06-stores/Svelte_stores.md) or at [MDN web docs](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_stores).

The source code to follow this article is in the `06-stores` folder, you can download it with the `npx degit opensas/mdn-svelte-tutorial/06-stores svelte-todo` command. You can also play with an online version using this Svelte [REPL](https://svelte.dev/repl/d1fa84a5a4494366b179c87395940039?version=3.23.2).

## 07. TypeScript support in Svelte

In this article will learn how to use TypeScript to develop Svelte applications. First we'll learn what is TypeScript and what benefits it can bring us. Then we'll see how to configure our project to work with TypeScript files. Finally we will go over our app and see what modifications we have to make to fully take advantage of TypeScript features.

You can see the complete content of this article [here](./07-typescript-support/Svelte_typescript_support.md) or at [MDN web docs](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_TypeScript).

The source code to follow this article is in the `07-typescript-support` folder, you can download it with the `npx degit opensas/mdn-svelte-tutorial/07-typescript-support svelte-todo` command. 

The application ported to TypeScript is in the `08-next-steps` folder, you can download it with the `npx degit opensas/mdn-svelte-tutorial/08-next-steps svelte-todo` command.

> [TypeScript support](https://github.com/sveltejs/svelte-repl/issues/130) is not available from the REPL yet. You can download the content folder and work locally with `npx degit opensas/mdn-svelte-tutorial/07-typescript-support`.

## 08. Deployment and next Steps

In this article we will learn about a couple of zero-fuss options to deploy our app in production and see how to setup a basic pipeline to deploy our app to GitLab on every commit. We will also provide a list of Svelte resources to go further with your Svelte learning.

You can see the complete content of this article [here](./08-next-steps/Svelte_next_steps.md) or at [MDN web docs](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_next_steps).

The source code to follow this article is in the `08-next-steps` folder, you can download it with the `npx degit opensas/mdn-svelte-tutorial/08-next-steps svelte-todo` command. 