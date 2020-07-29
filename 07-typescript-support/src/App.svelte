<!-- App.svelte -->
<script>
  import Todos from './components/Todos.svelte'
  import Alert from './components/Alert.svelte'

  import { todos } from './stores.js'
</script>

<Alert />
<Todos bind:todos={$todos} />
