<!-- App.svelte -->
<script lang="ts">
  import Todos from './components/Todos.svelte'
  import Alert from './components/Alert.svelte'

  import { todos } from './stores'
</script>

<Alert />
<Todos bind:todos={$todos} />
