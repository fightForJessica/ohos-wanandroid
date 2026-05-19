import { ArticalDetail, ArticalResponse } from "../model/ArticalData";
import { BannerData, BannerResponse } from "../model/BannerData";
import { LoadingState } from "../model/LoadingState";
import { MainResposity } from "../resposity/MainResposity";
import ListDataSource from "../utils/ListDataSource";
import Logger from "../utils/Logger";


@Observed
export default class MainViewModel {

  private resposity = new MainResposity()

  @Track bannerDatas: BannerData[] = []
  @Track bannerLoadingState = LoadingState.NONE

  @Track articalDatas: ListDataSource<ArticalDetail>= new ListDataSource()
  @Track articalLoadingState = LoadingState.NONE
  private articalPagePosition = 0 // 游标

  async fetchBannerData() {
    this.bannerLoadingState = LoadingState.INIT_LOADING
    this.bannerDatas = []
    Logger.i("banner data requesting")
    await this.resposity.fetchBannerData().then((result: BannerResponse) => {
      let datas = result.data
      if (datas != null && datas?.length != 0) {
        Logger.i("banner data request success: ".concat(JSON.stringify(result)))
        Logger.i("banner data is: ".concat(JSON.stringify(datas)))
        this.bannerLoadingState = LoadingState.SUCCESS
        this.bannerDatas = datas
      } else {
        this.bannerLoadingState = LoadingState.ERROR
      }
    }).catch(() => {
      this.bannerLoadingState = LoadingState.ERROR
      Logger.i("artical data request error")
    })
  }

  async fetchArticalData(more: boolean) {
    if (more) {
      this.articalLoadingState = LoadingState.MORE_LOADING
    } else {
      this.articalLoadingState = LoadingState.INIT_LOADING
      this.articalPagePosition = 0
    }
    Logger.i("artical data requesting, more: ".concat(more.toString()))
    await this.resposity.fetchArticalData(this.articalPagePosition).then((result: ArticalResponse) => {
      let details = result.data?.datas
      if (details != null && details.length != 0) {
        this.articalLoadingState = LoadingState.SUCCESS
        if (more) {
          this.articalDatas.loadData(details)
        } else {
          this.articalDatas.addDataList(details)
        }
        Logger.i("artical data request success: ".concat(JSON.stringify(result)))
        // todo noMore 加载完成判断
      } else {
        this.articalLoadingState = LoadingState.ERROR
        Logger.i("artical data request failure: ".concat(JSON.stringify(result)))
      }
    }).catch(() => {
      this.articalLoadingState = LoadingState.ERROR
      Logger.i("artical data request error")
    })

  }

}