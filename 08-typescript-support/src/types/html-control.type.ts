// export class Focusable {
//   focus?(): void
// }

export type Focusable = { focus?(): void }

export type HTMLControl = Node & { focus?(): void }
