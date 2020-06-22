<!-- components/Todos.svelte -->
<script>
  import FilterButton from './FilterButton.svelte'
  import Todo from './Todo.svelte'
  import MoreActions from './MoreActions.svelte'
  import NewTodo from './NewTodo.svelte'  
  import TodosStatus from './TodosStatus.svelte'
  
  export let todos = []

  let todosStatus                   // reference to TodosStatus instance

  $: newTodoId = todos.length ? Math.max(...todos.map(t => t.id)) + 1 : 1

  function removeTodo(todo) {
    todos = todos.filter(t => t.id !== todo.id)
    todosStatus.focus()             // give focus to status heading
  }

  function addTodo(name) {
    todos = [...todos, { id: newTodoId, name, completed: false }]
  }

  function updateTodo(todo) {
    const i = todos.findIndex(t => t.id === todo.id)
    todos[i] = { ...todos[i], ...todo }
  }

  let filter = 'all'
  const filterTodos = (filter, todos) => 
    filter === 'active' ? todos.filter(t => !t.completed) :
    filter === 'completed' ? todos.filter(t => t.completed) : 
    todos

  const checkAllTodos = (completed) => {
    todos = todos.map(t => ({...t, completed}))
  }

  const removeCompletedTodos = () => todos = todos.filter(t => !t.completed)

</script>

<!-- Todos.svelte -->
<div class="todoapp stack-large">

  <!-- NewTodo -->
  <NewTodo autofocus on:addTodo={e => addTodo(e.detail)} />

  <!-- Filter -->
  <FilterButton bind:filter />

  <!-- TodosStatus -->
  <TodosStatus bind:this={todosStatus} {todos} />

  <!-- Todos -->
  <ul role="list" class="todo-list stack-large" aria-labelledby="list-heading">
  {#each filterTodos(filter, todos) as todo (todo.id)}
    <li class="todo">
      <Todo {todo}
        on:update={e => updateTodo(e.detail)}
        on:remove={e => removeTodo(e.detail)}
      />
    </li>
  {:else}
    <li>Nothing to do here!</li>
  {/each}
  </ul>

  <hr />

  <!-- MoreActions -->
  <MoreActions {todos}
    on:checkAll={e => checkAllTodos(e.detail)}
    on:removeCompleted={removeCompletedTodos}
  />

</div>