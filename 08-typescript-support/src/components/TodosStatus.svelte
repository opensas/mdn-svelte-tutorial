<!-- components/TodosStatus.svelte -->
<script context='module' lang='ts'>
  export type TodosStatusType =  SvelteComponent & { focus(): void }
</script>

<script lang='ts'>
  import type { TodoType } from "../types/todo.type"

  export let todos: TodoType[]

  let totalTodos: number
  let completedTodos: number

  $: totalTodos = todos.length
  $: completedTodos = todos.filter(todo => todo.completed).length

  let headingEl: HTMLElement

  export const focus = () => headingEl.focus()

</script>

<h2 id="list-heading" bind:this={headingEl} tabindex="-1">{completedTodos} out of {totalTodos} items completed</h2>