<!-- components/TodosStatus.svelte -->
<script lang='ts'>
  import { TodoEntity } from "../interfaces/todo.interface";

  export let todos: TodoEntity[]

  import { Focusable } from "../interfaces/focusable.interface";

  let totalTodos: number
  let completedTodos: number

  $: totalTodos = todos.length
  $: completedTodos = todos.filter(todo => todo.completed).length

  let headingEl: Focusable

  export const focus = () => headingEl.focus()

</script>

<h2 id="list-heading" bind:this={headingEl} tabindex="-1">{completedTodos} out of {totalTodos} items completed</h2>