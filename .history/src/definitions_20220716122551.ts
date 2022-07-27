export interface Plumb5Plugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
