<!-- components/MoreActions.svelte -->
<script lang="ts">
  import { createEventDispatcher } from 'svelte'
  const dispatch = createEventDispatcher()

  import { TodoEntity } from '../interfaces/todo.interface';

  export let todos: TodoEntity[]

  let completed = true

  const checkAll = () => {
    dispatch('checkAll', completed)
    completed = !completed
  }

  const removeCompleted = () => dispatch('removeCompleted')

  let completedTodos: number
  $: completedTodos = todos.filter((t: TodoEntity) => t.completed).length
</script>

<div class="btn-group">
  <button type="button" class="btn btn__primary" 
    disabled={todos.length === 0} on:click={checkAll}>{completed ? 'Check' : 'Uncheck'} all</button>
  <button type="button" class="btn btn__primary" 
    disabled={completedTodos === 0} on:click={removeCompleted}>Remove completed</button>
</div>