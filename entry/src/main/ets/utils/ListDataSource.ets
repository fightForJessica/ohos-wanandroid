
export default class ListDataSource<T> implements IDataSource {

  /** 原始数组 */
  private originData: T[] = []

  /** 监听器 */
  private listeners: DataChangeListener[] = []

  /** 获取总数 */
  totalCount(): number {
    return this.originData.length;
  }

  /** 根据索引获取数据 */
  getData(index: number): T {
    return this.originData[index];
  }

  /** 添加一条数据 */
  addData(item: T) {
    const index = this.originData.length
    this.originData.push(item)
    this.notifyDataAdd(index)
  }

  /** 添加多条数据 */
  addDataList(items: T[]) {
    const startIndex = this.originData.length
    this.originData.push(...items)
    for (let i = 0; i < items.length; i++) {
      this.notifyDataAdd(startIndex + i)
    }
  }

  /** 根据索引移除一条数据 */
  removeData(index: number) {
    this.originData.splice(index, 1)
    this.notifyDataDelete(index)
  }

  /** 加载数据 */
  loadData(items: T[]) {
    this.originData = []
    this.addDataList(items)
  }

  /** 注册时触发 /注册监听 */
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  /** 移除时触发 /解除监听 */
  unregisterDataChangeListener(listener: DataChangeListener): void {
    let index = this.listeners.indexOf(listener)
    if (index >= 0) {
      this.listeners.splice(index, 1)
    }
  }

  notifyDataReload() {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  notifyDataAdd(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index)
    })
  }

  notifyDataChange(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataChange(index)
    })
  }

  notifyDataDelete(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index)
    })
  }

}