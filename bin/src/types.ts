import om from 'omelette'

export interface Script {
  run(): Promise<void>
  getAutocomplete?(): om.Instance
}
