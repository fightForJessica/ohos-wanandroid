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
    Logger.i("fetchBannerData start")
    await this.resposity.fetchBannerData().then((result: BannerResponse) => {
      let datas = result.data
      if (datas != null && datas?.length != 0) {
        Logger.i(`fetchBannerData success, banner data: ${JSON.stringify(datas)}`)
        this.bannerLoadingState = LoadingState.SUCCESS
        this.bannerDatas = datas
      } else {
        this.bannerLoadingState = LoadingState.ERROR
      }
    }).catch(() => {
      this.bannerLoadingState = LoadingState.ERROR
      Logger.i("fetchBannerData error")
    })
  }

  async reloadArticalData() {
    if (this.articalLoadingState == LoadingState.MORE_LOADING || this.articalLoadingState == LoadingState.INIT_LOADING) {
      return
    }
    let more = this.articalPagePosition == 0
    // 失败重新加载时不需要更改索引
    if (more) {
      this.articalLoadingState = LoadingState.MORE_LOADING
    } else {
      this.articalLoadingState = LoadingState.INIT_LOADING
    }
    Logger.i(`reloadArticalData, more: ${more}, articalPagePosition: ${this.articalPagePosition}`)
    this.realFetchArticalData(more)
  }

  async fetchArticalData(more: boolean) {
    if (this.articalLoadingState == LoadingState.MORE_LOADING || this.articalLoadingState == LoadingState.INIT_LOADING) {
      return
    }
    if (more) {
      this.articalLoadingState = LoadingState.MORE_LOADING
      this.articalPagePosition++
    } else {
      this.articalLoadingState = LoadingState.INIT_LOADING
    }
    Logger.i(`fetchArticalData, more: ${more}, articalPagePosition: ${this.articalPagePosition}`)
    this.realFetchArticalData(more)
  }

  private async realFetchArticalData(more: boolean) {
    Logger.i(`realFetchArticalData, more: ${more}, articalPagePosition: ${this.articalPagePosition}`)
    await this.resposity.fetchArticalData(this.articalPagePosition).then((result: ArticalResponse) => {
      let details = result.data?.datas
      if (details != null && details.length != 0) {
        this.articalLoadingState = LoadingState.SUCCESS
        if (more) {
          this.articalDatas.loadData(details)
        } else {
          this.articalDatas.addDataList(details)
        }
        Logger.i(`realFetchArticalData success: ${JSON.stringify(result)}`)
      } else {
        this.articalLoadingState = LoadingState.ERROR
        Logger.i(`realFetchArticalData failure: ${JSON.stringify(result)}`)
      }

    }).catch(() => {
      this.articalLoadingState = LoadingState.ERROR
      Logger.i("realFetchArticalData error")
    })
  }

}