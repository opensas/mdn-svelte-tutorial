# Svelte advanced concepts

In the last article we added more features to our To-Do list and started to organize our app into components. In this article we will add the app's final features and further componentize our app. 

We will learn how to deal with reactivity issues related to updating objects and arrays. To avoid common pitfalls, we'll have to dig a little deeper into Svelte's reactivity system.

Then we will focus on some accessibility issues involving focus management. To do so, we'll have to discuss some advanced techniques to access DOM nodes and execute methods like `focus()` and `select()`. We will also see how to declare and clean-up event listeners on DOM elements. More over, we'll have to learn a bit about components lifecycle, to understand when these DOM nodes get mounted and and unmounted from the DOM and how we can access them. We will also learn about the `action` directive, which will allow us to extend the functionality of HTML elements in a reusable and declarative way.

Finally, we will learn a bit more about components. So far now, we saw how components can share data using _props_, and communicate with their parent using events od two-way data binding. Now we will see how components can also expose methods and variables to access them programmatically.

All this topics will be covered while we develop the following components:

- MoreActions: Displays the "Check All" and "Remove Completed" buttons, emitting the correspondent events.

- NewTodo: Displays the input box and _Add_ button for adding a new todo

- TodosStatus: Displays the 'x out of y items completed' label

> **Prerequisites**: Familiarity with the core HTML, CSS, and JavaScript languages, knowledge of the terminal/command line.
> 
> **Objective**: Learn some advanced Svelte techniques.

## Coding along with us

If you want to get the app's code to start coding you can clone the github repo (if you haven't already done it) with `git clone https://github.com/opensas/mdn-svelte-tutorial.git` and then `cd mdn-svelte-tutorial/05-advanced-concepts`, or you may directly download the folder's content with `npx degit opensas/mdn-svelte-tutorial/05-advanced-concepts`. Remember to run `npm install && npm run dev` to start you app in development mode. You can also follow us online using this [REPL](https://svelte.dev/repl/76cc90c43a37452e8c7f70521f88b698?version=3.23.2).

## Adding more features

Now we'll tackle the `Check All` and `Remove Completed` buttons. Let's create a component that will be in charge of displaying the buttons and emitting the corresponding events.

Create the file `components/MoreActions.svelte`.

When the first button is clicked we'll emit a `checkAll` event to signal that all the todos should be checked/unchecked. When the second button is clicked, we'll emit a `removeCompleted` event to signal that all of the completed todos should be removed. Put the following content into your MoreActions.svelte file:

```html
<script>
  import { createEventDispatcher } from 'svelte'
  const dispatch = createEventDispatcher()

  let completed = true

  const checkAll = () => {
    dispatch('checkAll', completed)
    completed = !completed
  }

  const removeCompleted = () => dispatch('removeCompleted')

</script>

<div class="btn-group">
  <button type="button" class="btn btn__primary" on:click={checkAll}>{completed ? 'Check' : 'Uncheck'} all</button>
  <button type="button" class="btn btn__primary" on:click={removeCompleted}>Remove completed</button>
</div>
```

We've also included a `completed` variable to toggle between _checking_ and _unchecking_ all tasks.

Back over in `Todos.svelte` we are going to import our `MoreActions` component and create two functions to handle the events emitted by the MoreActions component.

Add the following import statement below the existing ones:

```js
  import MoreActions from './MoreActions.svelte'
```

Then add the described functions at the end of the `<script>` section:

```js
  const checkAllTodos = (completed) => todos.forEach(t => t.completed = completed)

  const removeCompletedTodos = () => todos = todos.filter(t => !t.completed)
```

Now go to the bottom of the Todos.svelte markup section and replace the btn-group `<div>` that we copied into `MoreActions.svelte` with a call to the `MoreActions` component, like so: 

```html
  <!-- MoreActions -->
  <MoreActions 
    on:checkAll={e => checkAllTodos(e.detail)}
    on:removeCompleted={removeCompletedTodos}
  />
```

OK, let's go back into the app and try it out! You'll find that the `Remove Completed` button works fine, but the `Check All`/`Uncheck All` button just silently fails. To find out what is happening here, we'll have to dig a little deeper into Svelte reactivity.

## Reactivity gotchas: updating objects and arrays

To see what's happening we can log the `todos` array from the `checkAllTodos` function to the console. Update your existing `checkAllTodos()` function to the following:

```javascript
  const checkAllTodos = (completed) => {
    todos.forEach(t => t.completed = completed)
    console.log('todos', todos)
  }
```

Go back to your browser, open your DevTools console, and click `Check All`/`Uncheck All` a few times. You'll notice that the array is successfully updated every time you press the button (the todo objects' completed properties are toggled between true and false), but Svelte is not aware of that. That also means that in this case a reactive statement like `$: console.log('todos', todos)` won't be very useful.

To find out why this is happening, we need to understand how reactivity works in Svelte when [updating arrays and objects](https://svelte.dev/tutorial/updating-arrays-and-objects).

Many web frameworks use the [virtual DOM](https://reactjs.org/docs/faq-internals.html) technique to update the page. Basically, the virtual DOM is an in-memory copy of the contents of the web page. The framework updates this virtual representation which is then synced with the "real" DOM. This is much faster than directly updating the DOM and allows the framework to apply many optimization techniques.

These frameworks, by default, basically rerun all our JavaScript on every change against this virtual DOM, and apply different methods to cache expensive calculations and optimize execution. They make little to no attempt to understand what our JavaScript code is doing. 

Svelte doesn't use a virtual DOM representation. Instead, it parses and analyzes our code, creates a dependency tree, and then generates the required JavaScript to update only the parts of the DOM that need to be updated. This approach usually generates optimal JavaScript code with minimal overhead, but it also has its limitations.

Sometimes Svelte cannot detect changes to variables being watched. Remember that to tell Svelte that a variable has changed, you have to assign it a new value. 

A simple rule of thumb: The name of **the updated variable must appear on the left hand side of the assignment**.

For example, in the following piece of code:

```javascript
const foo = obj.foo
foo.bar = 'baz'
```

Svelte won't update references to `obj.foo.bar`, unless you follow it up with `obj = obj`. That's because Svelte can't track object references, so we have to explicitly tell that `obj` has changed by issuing an assignment. 

> Tip: if `foo` is a top level variable, you can easily tell Svelte to update `obj` whenever `foo` is changed with the following reactive statement: `$: foo, obj = obj`. With this we are defining `foo` as a dependency, and whenever it changes Svelte will run `obj = obj`.

In our `checkAllTodos()` function, when we run:

```
todos.forEach(t => t.completed = completed)
```

Svelte will not mark `todos` as changed because it does not know that when we update our `t` variable inside the `forEach()` we are also modifying the `todos` array. And that makes sense, because otherwise Svelte should be aware of the inner workings of the `forEach()` method, and in fact for any method that you could have attached to any object or array.

Nevertheless, there are different techniques that we can apply to solve this problem., all of them involves assigning a new value to the variable being watched.

Like we already saw, we could just tell Svelte to update the variable with a self-assignment, like this:

```javascript
const checkAllTodos = (completed) => {
  todos.forEach(t => t.completed = completed)
  todos = todos
}
```

This will solve the problem. Internally Svelte will flag `todos` as changed and remove the apparently redundant self-assignment. Apart from the fact that it looks weird, it's perfectly ok to use this technique, and sometimes it's the most concise way to do it. 

We could also access the `todos` array by index, like this:

```javascript
const checkAllTodos = (completed) => {
  todos.forEach( (t,i) => todos[i].completed = completed)
}
```

Assignments to properties of arrays and objects — e.g. `obj.foo += 1` or `array[i] = x` — work the same way as assignments to the values themselves. When Svelte analyzes this code, if can detect that the `todos` array is being modified.

Another solution is to assign a new array to `todos`, containing a copy of all the todos with the `completed` property updated accordingly, like this:

```javascript
const checkAllTodos = (completed) => {
  todos = todos.map(t => {                  // shorter version: todos = todos.map(t => ({...t, completed}))
    return {...t, completed: completed}
  })
}
```

In this case we are using the map [map()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map) method, which returns a new array with the results of executing the provided function for each item. The function returns a copy of each todo using the [spread syntax](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax) and overwrites the property of the completed value accordingly. This solution has the added benefit of returning a new array with new objects, completely avoiding mutating the original `todos` array.

> Svelte allows us to specify different options that affect how the compiler works. One of them. The `<svelte:options immutable={true}/>` tells the compiler that you promise not to mutate any objects. This allows it to be less conservative about checking whether values have changed and generate simpler and more performant code. For more information on `<svelte:options...>` check the [documentation](https://svelte.dev/docs#svelte_options).

All of these solutions involve an assignment in which the updated variable is on the left side of the equation. Any of this techniques will allow Svelte to notice that our `todos` array has been modified.

Choose one, and update your `checkAllTodos()` function as required. Now you should be able to check and uncheck all your todos at once. Try it!

## Completing our MoreActions component

We will add one usability detail to our component. We'll disable the buttons when there are no tasks to be processed.

For that we'll receive the `todos` array as a prop, and set the `disabled` property of each button accordingly. Update your MoreActions.svelte component like this:

```html
<script>
  import { createEventDispatcher } from 'svelte'
  const dispatch = createEventDispatcher()

  export let todos

  let completed = true

  const checkAll = () => {
    dispatch('checkAll', completed)
    completed = !completed
  }

  const removeCompleted = () => dispatch('removeCompleted')

  $: completedTodos = todos.filter(t => t.completed).length
</script>

<div class="btn-group">
  <button type="button" class="btn btn__primary" 
    disabled={todos.length === 0} on:click={checkAll}>{completed ? 'Check' : 'Uncheck'} all</button>
  <button type="button" class="btn btn__primary" 
    disabled={completedTodos === 0} on:click={removeCompleted}>Remove completed</button>
</div>
```

We've also declare a reactive `completedTodos` variable to enable or disable the _Remove completed_ button.

Don't forget to pass the prop into MoreActions from inside `Todos.svelte`, where the component is called:

```html
  <MoreActions {todos}
    on:checkAll={e => checkAllTodos(e.detail)}
    on:removeCompleted={removeCompletedTodos}
  />
```

## Working with the DOM: focusing on the details

Now that we have completed all of the app's required functionality, we'll concentrate on some accessibility features that will improve the usability of our app for both keyboard-only and screenreader users. 

In its current state our app has a couple of keyboard accessibility problems involving focus management. Let's have a look at these issues.

### Exploring keyboard accessibility issues in our todo app

Right now, keyboard users will find out that the focus flow of our app is not very predictable nor coherent.

If you click on the on the input at the top of our app, you'll see a thick, dashed outline around that input. This outline is your visual indicator that the browser is currently focused on this element. If you are a mouse user, you might have skipped this visual hint. But if you are working exclusively with the keyboard, knowing which control has focus is of vital importance. It tells us which control is going to receive our keystrokes.

If you press the `Tab` key repeatedly, you'll see the dashed focus indicator cycling between all the elements in our page. If you take the focus to the _Edit_ button and press enter, suddenly the focus disappears, you can no longer tell which control will receive our keystrokes. Moreover, if you press the `Escape` or `Enter` key nothing happens. And if you click on _Cancel_ or _Save_ the focus disappears again. For a user working with the keyboard, that kind of behavior will be confusing at best.

We'd also like to add some usability features, like disabling the _Save_ button when required fields are empty, giving focus to certain HTML elements or auto-selecting contents when a text input receives focus.

To implement all these features we'll need programmatic access to DOM nodes to run functions like `node.focus()` and `node.select()`. We will also have to use `node.addEventListener()` and `node.removeEventListener()` to do specific tasks when the control receives focus.

The problem is that all these DOM nodes are dynamically created by Svelte at runtime. So we'll have to wait for them to be created and added to the DOM, in order to use them. To do so, we'll have to learn about the [components lifecycle](https://svelte.dev/tutorial/onmount) to understand when we can access them.

### Creating a NewTodo component 

Let's begin by extracting our new todo form out to its own component. With what we know so far we can create a new component file and adjust the code to emit the `addTodo` event, passing the name of the new todo as additional details.

Create a new file — `components/NewTodo.svelte`.

Put the following contents inside it:

```html
<script>
  import { createEventDispatcher } from 'svelte'
  const dispatch = createEventDispatcher()

  let name = ''

  const addTodo = () => {
    dispatch('addTodo', name)
    name = ''
  }

  const onCancel = () => name = ''

</script>

<form on:submit|preventDefault={addTodo} on:keydown={e => e.key === 'Escape' && onCancel()}>
  <h2 class="label-wrapper">
    <label for="todo-0" class="label__lg">What needs to be done?</label>
  </h2>
  <input bind:value={name} type="text" id="todo-0" autoComplete="off" class="input input__lg" />
  <button type="submit" disabled={!name} class="btn btn__primary btn__lg">Add</button>
</form>
```

Here we are binding the input to the `name` variable with `bind:value={name}` and disabling the _add_ button when the text is empty using `disabled={!name}`. We are also taking care of the `Escape` key with `on:keydown={e => e.key === 'Escape' && onCancel()}`. Whenever the `Escape` key is pressed we run `onCancel()`, which just clears up the `name` variable.

Now we have to import and use it from inside the `Todos` component, and update the `addTodo()` function to receive the name of the new todo.

Add the following import statement below the others:

```js
import NewTodo from './NewTodo.svelte'
```

And update the `addTodo()` function like so:

```javascript
function addTodo(name) {
  todos = [...todos, { id: newTodoId, name, completed: false }]
}
```

`addTodo()` now receives the name of the new todo directly, so we no longer needs the `newTodoName` variable to give it its value. Our `NewTodo` component takes care of that. 

> Note: the `{ name }` syntax it's just a shorthand for `{ name: name }`. This one comes from JavaScript itself and has nothing to do with Svelte, besides giving it some inspiration for Svelte's own shorthands.

Finally for this change, replace the `NewTodo` form markup with a call to `NewTodo` component, like so:

```html
  <!-- NewTodo -->
  <NewTodo on:addTodo={e => addTodo(e.detail)} />
```

## Working with DOM nodes using the `bind:this={dom_node}` directive

Now we want the `NewTodo` input to get focus again, every time the _Add_ button is pressed. For that we'll need a reference to the DOM node of the input. Svelte provides a way to do this with the [bind:this={dom_node}](https://svelte.dev/docs#bind_element) directive. If specified, as soon as the component is mounted and the DOM node is created, Svelte assigns a reference to the DOM node to the specified variable.

We'll create a `nameEl` variable and bind it to the input it using `bind:this={nameEl}`. Then inside `addTodo()`, after adding the new todo we will call `nameEl.focus()` to focus the input again. We will do the same when the user presses the `Escape` key in the `onCancel()` function.

Update the contents of NewTodo.svelte like so:

```html
<script>
  import { createEventDispatcher } from 'svelte'
  const dispatch = createEventDispatcher()

  let name = ''
  let nameEl                  // reference to the name input DOM node

  const addTodo = () => {
    dispatch('addTodo', name)
    name = ''
    nameEl.focus()            // give focus to the name input
  }

  const onCancel = () => {
    name = ''
    nameEl.focus()            // give focus to the name input
  }

</script>

<form on:submit|preventDefault={addTodo} on:keydown={e => e.key === 'Escape' && onCancel()}>
  <h2 class="label-wrapper">
    <label for="todo-0" class="label__lg">What needs to be done?</label>
  </h2>
  <input bind:value={name} bind:this={nameEl} type="text" id="todo-0" autoComplete="off" class="input input__lg" />
  <button type="submit" disabled={!name} class="btn btn__primary btn__lg">Add</button>
</form>
```

Try the app out — type a new todo name in to the input field, press _tab_ to give focus to the _Add_ button, and then hit _Enter_ or _Escape_ to see how the input recovers focus.

The next feature will add to our `NewTodo` component will be an `autofocus` prop, which will allow us to specify that we want the input field to be focused on load.

Our first attempt is as follows — let's try adding the `autofocus` prop and just call `nameEl.focus()` from the `<script>` block. Update the first part of the NewTodo.svelte `<script>` section (the first four lines) to look like this:

```html
<script>
  import { createEventDispatcher } from 'svelte'
  const dispatch = createEventDispatcher()

  export let autofocus = false

  let name = ''
  let nameEl                  // reference to the name input DOM node

  if (autofocus) nameEl.focus()
```

Now go back to the `Todos` component, and pass the autofocus prop into the `<NewTodo>` component call, like so:

```html
  <!-- NewTodo -->
  <NewTodo autofocus on:addTodo={e => addTodo(e.detail)} />
```

If you try your app out now, you'll see that the page is now blank, and in your DevTools web console you'll see an error along the lines of: `TypeError: nameEl is undefined`.

To understand what's happening here, we'll have to talk a little bit about the [lifecycle of components](https://svelte.dev/tutorial/onmount).

## Components lifecycle: `onMount()` function

When a component is instantiated, Svelte runs the initialization code (that is, the `<script>` section of the component). But at that moment, all the nodes that compose the component are not attached to the DOM, in fact, they don't even exist.

So, how can you know when the component has already been created and mounted on the DOM? Every component has a lifecycle that starts when it is created, and ends when it is destroyed. There are a handful of functions that allow you to run code at key moments during that lifecycle.

The one you'll use most frequently is `onMount`, which lets us run a callback as soon as the component has been mounted on the DOM. Let's give it a try and see what happens to the `nameEl` variable.

To start with, add the following line at the beginning of the NewTodo.svelte `<script>` section:

```javascript
  import { onMount } from 'svelte'
```

And these lines at the end:

```javascript
  console.log('initializing:', nameEl)
  onMount( () => {
    console.log('mounted:', nameEl)
  })
```

Now remove the `if (autofocus) nameEl.focus()` line to avoid throwing the error we were seeing before.

The app will now work again, and you'll see the following in your console:

```
initializing: undefined
mounted: <input id="todo-0" class="input input__lg" type="text" autocomplete="off">
```

As you can see, while the component is initializing `nameEl` is undefined, which makes sense because the node input doesn't even exist yet. After the component has been mounted, Svelte assigned a reference of the DOM node to the `nameEl` variable thanks to the `bind:this={nameEl}` directive.

So this looks like it's going to work! To get the autofocus functionality working, replace the previous console.log/onMount block you added with this:

```js
  onMount(() => autofocus && nameEl.focus())    // if autofocus is true, we run nameEl.focus()
```

Go to your app again, and you'll now see the input field is focused on page load.

Note: You can have a look at the other [lifecycle functions](https://svelte.dev/docs#svelte) in the Svelte docs, and you can see them in action in the [interactive tutorial](https://svelte.dev/tutorial/onmount).

## Waiting for the DOM to be updated with the `tick()` function

Now we will take care of the `Todo` component's focus management details. First of all, we want a todo component's _edit_ input to receive focus when we enter `editing` mode by pressing its Edit button. In the same fashion as we saw earlier, we'll create a `nameEl` variable inside Todo.svelte and call `nameEl.focus()` after setting the `editing` variable to true.

Open the file `components/Todo.svelte` and add a `nameEl` variable declaration, just below your `editing` and `name` declarations:

```js
  let nameEl                              // reference to the name input DOM node
```

Now update your onEdit() function like so:

```js
  function onEdit() {
    editing = true                        // enter editing mode
    nameEl.focus()                        // set focus to name input
  }
```

And finally, bind `nameEl` to the input field, by updating it like so:

```html
  <input bind:value={name} bind:this={nameEl} type="text" id="todo-{todo.id}" autoComplete="off" class="todo-text" />
```

However, when we you try the updated app you'll get an error along the lines of the following in the console when you press a todo's _Edit_ button:

```
TypeError: nameEl is undefined
```

So, what is happening here? When you update a component's state in Svelte, it doesn't update the DOM immediately. Instead, it waits until the next microtask to see if there are any other changes that need to be applied, including in other components. Doing so avoids unnecessary work and allows the browser to batch things more effectively.

In this case, when `editing` is false, the edit input is not visible because it does not exist in the DOM. Inside the `onEdit()` function we set `editing = true` and immediately afterwards try to access the `nameEl` variable and execute `nameEl.focus()`. The problem here is that Svelte hasn't yet updated the DOM.

One way to solve this problem is to use the [setTimeout()](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setTimeout) to delay the call to `nameEl.focus()` until the next event cycle, and give Svelte the opportunity to update the DOM.

Try this now:

```javascript
  function onEdit() {
    editing = true                        // enter editing mode
    setTimeout(() => nameEl.focus(), 0)   // asynchronous call to set focus to name input
  }
```

The above solution works, but it is rather inelegant. Svelte provides a better way to handle these cases. The [tick()](https://svelte.dev/tutorial/tick) function returns a promise that resolves as soon as any pending state changes have been applied to the DOM (or immediately, if there are no pending state changes). Let's try it now.

First of all, import it at the top of the `<script>` section alongside your existing import:

```javascript
  import { tick } from 'svelte'
```

Next, call tick() with `await` from an async function; update onEdit() like so:

```javascript
  async function onEdit() {
    editing = true                        // enter editing mode
    await tick()
    nameEl.focus()
  }
```

If you try it now you'll see that everything works as expected.

> Note: To see another example using `tick()`, visit the [Svelte tutorial](https://svelte.dev/tutorial/tick).

## Adding functionality to HTML elements with the `use:action` directive

Next up, we want the name input to automatically select all text on focus. Moreover, we want to develop this in such a way that it could be easily reused on any HTML input and applied in a declarative way. We will use this requirement as an excuse to show a very powerful feature that Svelte provides us to add functionality to regular HTML elements: [actions](https://svelte.dev/docs#use_action)

To select the text of a DOM input node we have to call `node.select()`. To get this function called whenever the node gets focused, we need an event listener along these lines: `node.addEventListener('focus', event => node.select())`. And, in order to avoid memory leaks, we should also call the `node.removeEventLister()` function when the node is destroyed.

> Note: All this is just standard WebAPI functionality; nothing here is specific to Svelte.

We could achieve all this in our `Todo` component whenever we add or remove the input from the DOM, but we would have to be very careful to add the event listener after the node has been added to the DOM, and remove the listener before the node is removed from the DOM. In addition, our solution would not be very reusable.

That's where Svelte [actions](https://svelte.dev/docs#use_action) come into play. Basically they let us run a function whenever an element has been added to the DOM, and after removal from the DOM.

In our immediate use case, we will define a function called `selectOnFocus()` that will receive a node as parameter. The function will add an event listener to that node, so that whenever it gets focused it will select the text. Then it will return an object with a `destroy` property. The `destroy` property is what Svelte will execute after removing the node from the DOM. Here we will remove the listener to make sure we don't leave any memory leak behind.

Let's create the function selectOnFocus(). Add the following to the bottom of the Todo.svelte `<script>` section:

```javascript
function selectOnFocus(node) {
  if (node && typeof node.select === 'function' ) {               // make sure node is defined and has a select() method
    const onFocus = event => node.select()                        // event handler
    node.addEventListener('focus', onFocus)                       // when node gets focus call onFocus()
    return {
      destroy: () => node.removeEventListener('focus', onFocus)   // this will be executed when the node is removed from the DOM
    }
  }
}
```

Now we need to tell the input to _use_ that function with the [use:action](https://svelte.dev/docs#use_action) directive:

```html
    <input use:selectOnFocus />
```

With this directive ww are telling Svelte to run this function, passing the DOM node of the input as a parameter, as soon as the component is mounted on the DOM. It will also be in charge of executing the `destroy` function when the component is removed from DOM. So, with the `use` directive, Svelte takes care of the components lifecycle for us.

In our case, our input would end up like so — update the component's first label/input pair (inside the edit template) like so:

```html
<label for="todo-{todo.id}" class="todo-label">New name for '{todo.name}'</label>
<input bind:value={name} bind:this={nameEl} use:selectOnFocus type="text" id="todo-{todo.id}" autoComplete="off" class="todo-text"
/>
```

Let's try it out. Go to your app, press the _edit_ button, then _tab_ to take focus away from the input. Now click on the input — you'll see that the entire input text is selected.

Now let's make this function truly reusable across components. `selectOnFocus()` is just a function without any dependency on the `Todo.svelte` component, so we can just extract it to a file and use it from there.

Create a new file, `actions.js`, inside the src folder.

Give it the following content:

```javascript
export function selectOnFocus(node) {
  if (node && typeof node.select === 'function' ) {               // make sure node is defined and has a select() method
    const onFocus = event => node.select()                        // event handler
    node.addEventListener('focus', onFocus)                       // when node gets focus call onFocus()
    return {
      destroy: () => node.removeEventListener('focus', onFocus)   // this will be executed when the node is removed from the DOM
    }
  }
}
```

Now import it from inside `Todo.svelte`; add the following import statement just below the others:

```javascript
import { selectOnFocus } from '../actions.js'
```

And remove the `selectOnFocus()` definition from `Todo.svelte` — we no longer need it there.

### Reusing our action

To demonstrate our action's reusability, let's make use of it in `NewTodo.svelte`.

Import `selectOnFocus()` from `actions.js` in this file too, as before:

```javascript
import { selectOnFocus } from '../actions.js'
```

 and add the `use:selectOnFocus` directive to the input, like this:

```html
<input bind:value={name} bind:this={nameEl} use:selectOnFocus 
  type="text" id="todo-0" autoComplete="off" class="input input__lg" 
/>
```

With a few lines of code we can add functionality to regular HTML elements, in a very reusable and declarative way. It just takes an import and a short directive like `use:selectOnFocus` that clearly depicts its purpose. And we can achieve this without the need to create a custom wrapper element like `TextInput`, `MyInput` or similar. Moreover, you can add as many `use:action` directives as you want to an element.

Also, we didn't have to struggle with `onMount`, `onDestroy` or `tick` — the `use` directive takes care of the component lifecycle for us.

In the previous section, while working with the `Todo` components, we had to deal with `bind:this`, `tick` and `async functions` just to give focus to our input as soon as it was added to the DOM. This is how we can implement it with actions instead:

```javascript
const focusOnInit = (node) => node && typeof node.focus === 'function' && node.focus()
```

And then in our markup we just need to add another use: directive:

```html
<input bind:value={name} use:selectOnFocus use:focusOnInit ...
```

Our `onEdit()` function can now be much simpler:

```javascript
function onEdit() {
  editing = true                        // enter editing mode
}
```

As a last example before we move on, let's get back to our `Todo.svelte` component and give focus to the _Edit_ button after the user presses _save_ or _cancel_. 

We could try just reusing once again our `focusOnInit` action adding `use:focusOnInit` to the edit button. But we'll be introducing a subtle bug. If you add a new todo, the focus will be on the edit button of the recently added todo. That's because the `focusOnInit` action is running when the component is created.

That's not what we wanted, we want the _edit_ button to receive focus **only** when the user has presses the edit button.

So, go back to your `Todo.svelte` file.

First of all we'll create a flag named `editButtonPressed` and initialize it to false. Add this just below your other variable definitions:

```javascript
let editButtonPressed = false           // track if edit button has been pressed, to give focus to it after cancel or save
```

Next, we'll modify the edit button's functionality to save this flag and create the action for the edit button. Update the onEdit() function like so: 

```javascript
function onEdit() {
  editButtonPressed = true              // user pressed the Edit button, focus will come back to the Edit button
  editing = true                        // enter editing mode
}
```

Below it, add the following definition for focusEditButton():

```js
const focusEditButton = (node) => editButtonPressed && node.focus()
```

Finally, we `use` the `focusEditButton` action on the Edit button, like so:

```html
<button type="button" class="btn" on:click={onEdit} use:focusEditButton>
  Edit<span class="visually-hidden"> {todo.name}</span>
</button>
```

Go back and try your app again. At this point, every time the _edit_ button is added to the DOM, the `focusEditButton` action is executed, but it will only give focus to the button if the `editButtonPressed` flag is true.

> We have barely scratched the surface of `actions` here. Actions can also have reactive parameters, and Svelte lets us detect when any of those parameters changes. So we can add functionality that integrates nicely with the Svelte reactive system. Have a look at [this article](https://svelte.school/tutorials/introduction-to-actions) for a more detailed introduction to actions. Actions are also very useful to seamlessly integrate third party libraries. [This article](https://svelte.school/tutorials/external-libraries-in-svelte-and-sapper-using-actions) tells you how to do it.

## Component binding: exposing component methods and variables using the `bind:this={component}` directive

There's still one accessibility annoyance left. When the user presses the _delete_ button, the focus seems to vanish in the air.

So, the last feature we will be looking at in this article involves setting the focus to the status heading after a todo has been deleted. 

Why the status heading? In this case, the element that had the focus has been deleted, so there's not a clear candidate to receive focus. We pick the status heading because it's near the list of todos, and it's a way to give a visual feedback about the removal of the task.

First we'll extract the status heading to its own component.

Create a new file — `components/TodosStatus.svelte` file.

Add the following contents to it:

```html
<script>
  export let todos

  $: totalTodos = todos.length
  $: completedTodos = todos.filter(todo => todo.completed).length
</script>

<h2 id="list-heading">{completedTodos} out of {totalTodos} items completed</h2>
```

Import the file at the beginning of `Todos.svelte`, adding the following import statement below the others:

```javascript
  import TodosStatus from './TodosStatus.svelte'
```

Replace the `h2` status heading inside Todos.svelte with the `TodosStatus` component, passing `todos` to it as a prop, like so:

```html
  <TodosStatus {todos} />
```

You can also do a bit of clean-up, removing the `totalTodos` and `completedTodos` variables from `Todos.svelte`

You can also do a bit of clean-up, removing the `totalTodos` and `completedTodos` variables from `Todos.svelte`. Just remove the `$: totalTodos = ..`. and the `$: completedTodos = ...` lines, and also replace the reference to `totalTodos` when we calculare `newTodoId` with `todos.length`, like this:

```javascript
$: newTodoId = todos.length ? Math.max(...todos.map(t => t.id)) + 1 : 1
```

Everything works as expected — we just extracted the last piece of markup to its own component.

Now we need to find a way to give focus to the `h2` status label after a todo has been removed.

So far we saw how to send information to a component via props, and how a component can communicate with its parent by emitting events or using two way data binding. The child component could get a reference to the `h2` node using `bind:this={dom_node}` and expose it to the outside using two-way data binding. But doing so would break the component encapsulation, setting focus on it should be its own responsibility. 

So we need the `TodosStatus` component to expose a method that its parent can call to give focus to it. It's a very common scenario that a component needs to expose some behavior or information to the consumer; let's see how to achieve it with Svelte.

We've already seen that Svelte uses `export let var = ...` to [declare props](https://svelte.dev/docs#1_export_creates_a_component_prop). But if instead of using `let` you export a `const`, `class` or `function`, it is readonly outside the component. Function expressions are valid props, however. In the following example the first three declarations are props, and the rest are exported values:

```html
<script>
  export let bar = 'optional default initial value'       // prop
  export let baz = undefined                              // prop
  export let format = n => n.toFixed(2)                   // prop

  // these are readonly
  export const thisIs = 'readonly'                        // read-only export

  export function greet(name) {                           // read-only export
    alert(`hello ${name}!`)
  }

  export const greet = (name) => alert(`hello ${name}!`)  // read-only export
</script>
```

With this in mind, let's go back to our use case. We'll create a function called `focus()` that gives focus to the `h2` heading. For that we'll need a `headingEl` variable to hold the reference to the DOM node and we'll have to bind it to the `<h2>` element using `bind:this={headingEl}`. Our focus method will just run `headingEl.focus()`. Update the contents of `TodosStatus.svelte` like so:

```html
<script>
  export let todos

  $: totalTodos = todos.length
  $: completedTodos = todos.filter(todo => todo.completed).length

  let headingEl

  export function focus() {   // shorter version: export const focus = () => headingEl.focus()
    headingEl.focus()
  }
</script>

<h2 id="list-heading" bind:this={headingEl} tabindex="-1">{completedTodos} out of {totalTodos} items completed</h2>
```

Note that we've added a [tabindex](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/tabindex) attribute to the `h2` to allow the element to receive focus programmatically.

As we saw earlier, using the `bind:this={headingEl}` directive gives us a reference to DOM node in the variable `headingEl`. Then we use `export function focus()` to expose a function that gives focus to the `h2` heading.

How can we access those exported values from the parent? Just as you can bind to DOM elements with the `bind:this={dom_node}` directive, you can also bind to component instances themselves with `bind:this={component}`. So , when you use `bind:this` on an HTML element, you get a reference to the DOM node, and when you do it on a Svelte component, you get a reference to the instance of that component.

So to bind to the instance of `TodosStatus` we'll first create a `todosStatus` variable in `Todos.svelte`. Add the following line below your import statements:

```javascript
  let todosStatus                   // reference to TodosStatus instance
```

Next, add a `bind:this={todosStatus}` directive to the <TodosStatus /> call, as follows:

```html
  <!-- TodosStatus -->
  <TodosStatus bind:this={todosStatus} {todos} />
```

Now we can call the exported `focus()` method from our `removeTodo()` function:

```javascript
  function removeTodo(todo) {
    todos = todos.filter(t => t.id !== todo.id)
    todosStatus.focus()             // give focus to status heading
  }
```

Go back to your app — now if you delete any todo, the status heading will be focussed — this is useful to highlight the change in numbers of todos, both to sighted users and screenreader users.

> Note: You might be wondering why we need to declare a new variable for component binding — why can't we just call `TodosStatus.focus()`? You might have multiple `TodosStatus` instances active, so you need a way to reference each particular instance. That's why you have to specify a variable to bind each specific instance to.

## Coding along with us

If you want to see how the app's code should look like by now you can clone the github repo (if you haven't already done it) with `git clone https://github.com/opensas/mdn-svelte-tutorial.git` and then `cd mdn-svelte-tutorial/06-stores`, or you may directly download the folder's content with `npx degit opensas/mdn-svelte-tutorial/06-stores`. Remember to run `npm install && npm run dev` to start you app in development mode. You can also follow us online using this [REPL](https://svelte.dev/repl/d1fa84a5a4494366b179c87395940039?version=3.23.2).

## Summary

In this article we have finished adding all the required functionality to our app, plus we've taken care of a number of accessibility and usability issues. We also finished splitting our app into manageable components, each one with a unique responsibility.

In the meantime, we saw a few advanced Svelte techniques, like:

- Dealing with reactivity gotchas when updating objects and arrays.
- Working with DOM nodes using `bind:this={dom_node}` (binding DOM elements).
- Component lifecycle: `onMount()` function.
- Force svelte to resolve pending state changes with the `tick()` function.
- Adding functionality to HTML elements in a reusable and declarative way with the `use:action` directive.
- Accessing component methods using `bind:this={component}` (binding components).

In the next article we will see how to use stores to communicate between components, and add animations to our components.
