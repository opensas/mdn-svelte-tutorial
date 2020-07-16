<!-- components/Todos.svelte -->
<script lang='ts'>
  import FilterButton from './FilterButton.svelte'
  import Todo from './Todo.svelte'
  import MoreActions from './MoreActions.svelte'
  import NewTodo from './NewTodo.svelte'
  import TodosStatus from './TodosStatus.svelte'
  import { alert } from '../stores'

  import { TodoEntity } from '../interfaces/todo.interface'

  import { Filter } from '../interfaces/filter.interface';

  export let todos: TodoEntity[] = []

  let todosStatus                   // reference to TodosStatus instance

  let newTodoId: number
  $: newTodoId = todos.length > 0 ? Math.max(...todos.map(t => t.id)) + 1 : 1

  function addTodo(e: CustomEvent<string>) {
    const { detail: name } = e
    todos = [...todos, { id: newTodoId, name, completed: false }]
    $alert = `Todo '${name}' has been added`
  }

  function removeTodo(e: CustomEvent<TodoEntity>) {
    const { detail: todo } = e
    todos = todos.filter(t => t.id !== todo.id)
    todosStatus.focus()             // give focus to status heading
    $alert = `Todo '${todo.name}' has been deleted`
  }

  function updateTodo(e: CustomEvent<TodoEntity>) {
    const { detail: todo } = e
    const i = todos.findIndex(t => t.id === todo.id)
    if (todos[i].name !== todo.name)            $alert = `todo '${todos[i].name}' has been renamed to '${todo.name}'`
    if (todos[i].completed !== todo.completed)  $alert = `todo '${todos[i].name}' marked as ${todo.completed ? 'completed' : 'active'}`
    todos[i] = { ...todos[i], ...todo }
  }

  let filter: Filter = Filter.ALL
  const filterTodos = (filter: Filter, todos: TodoEntity[]) => 
    filter === Filter.ACTIVE ? todos.filter(t => !t.completed) :
    filter === Filter.COMPLETED ? todos.filter(t => t.completed) : 
    todos

  $: {
    if (filter === Filter.ALL)               $alert = 'Browsing all todos'
    else if (filter === Filter.ACTIVE)       $alert = 'Browsing active todos'
    else if (filter === Filter.COMPLETED)    $alert = 'Browsing completed todos'
  }

  const checkAllTodos = (e: CustomEvent<boolean>) => {
    const { detail: completed } = e
    todos = todos.map(t => ({...t, completed}))
    $alert = `${completed ? 'Checked' : 'Unchecked'} ${todos.length} todos`
  }
  const removeCompletedTodos = () => {
    $alert = `Removed ${todos.filter(t => t.completed).length} todos`
    todos = todos.filter(t => !t.completed)
  }

</script>

<div class="todoapp stack-large">

  <!-- NewTodo -->
  <NewTodo autofocus on:addTodo={addTodo} />

  <!-- Filter -->
  <FilterButton bind:filter />

  <!-- TodosStatus -->
  <TodosStatus bind:this={todosStatus} {todos} />

  <!-- Todos -->
  <ul role="list" class="todo-list stack-large" aria-labelledby="list-heading">
  {#each filterTodos(filter, todos) as todo (todo.id)}
    <li class="todo">
      <Todo {todo}
        on:update={updateTodo}
        on:remove={removeTodo}
      />
    </li>
  {:else}
    <li>Nothing to do here!</li>
  {/each}
  </ul>

  <hr />

  <!-- MoreActions -->
  <MoreActions {todos}
    on:checkAll={checkAllTodos}
    on:removeCompleted={removeCompletedTodos}
  />

</div>