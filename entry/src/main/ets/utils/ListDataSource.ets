
export default class ListDataSource<T> implements IDataSource {

  /** 原始数组 */
  private originData: T[] = []
  /** 监听器 */
  private listener: DataChangeListener[] = [];

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
    this.originData.push(item);
  }

  /** 添加多条数据 */
  addDataList(items: T[]) {
    this.originData.push(...items);
    //通过listener通知数据更新
    this.listener.forEach(listener => {
      listener.onDataAdd(this.totalCount())
    })
  }

  /** 根据索引移除一条数据 */
  removeData(index: number) {
    this.originData.splice(index, 1);
  }

  /** 加载数据 */
  loadData(item: T[]) {
    this.originData = item;
  }

  /** 注册时触发 /注册监听 */
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listener.indexOf(listener) < 0) {
      this.listener.push(listener);
    }
  }

  /** 移除时触发 /解除监听 */
  unregisterDataChangeListener(listener: DataChangeListener): void {
    let index = this.listener.indexOf(listener)
    if (index > -1) {
      this.listener.splice(index, 1)
    }
  }
}