import { ArticalDetail, ArticalResponse } from "../model/mainpage/ArticalData";
import { BannerData, BannerResponse } from "../model/mainpage/BannerData";
import { LoadingState } from "../model/mainpage/LoadingState";
import { ProjectTreeItemData, ProjectTreeResponse } from "../model/mainpage/ProjectData";
import { MainResposity } from "../resposity/MainResposity";
import ListDataSource from "../utils/ListDataSource";
import Logger from "../utils/Logger";

@Observed
export class MainViewModel {

  private resposity = new MainResposity()

  @Track bannerDatas: BannerData[] = []
  @Track bannerLoadingState = LoadingState.NONE

  @Track articalDatas: ListDataSource<ArticalDetail>= new ListDataSource()
  @Track articalLoadingState = LoadingState.NONE
  private articalPagePosition = 0 // 游标

  @Track projectTreeData: ListDataSource<ProjectTreeItemData> = new ListDataSource()
  @Track projectTreeLoadingState = LoadingState.NONE

  async fetchBannerData() {
    if (this.checkLoading(this.bannerLoadingState)) {
      return
    }
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
    if (this.checkLoading(this.articalLoadingState)) {
      return
    }
    let more = this.articalPagePosition != 0
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
    if (this.checkLoading(this.articalLoadingState)) {
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
          this.articalDatas.addDataList(details)
        } else {
          this.articalDatas.loadData(details)
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

  async fetchProjectType() {
    Logger.i("fetchProjectType start")
    if (this.checkLoading(this.projectTreeLoadingState)) {
      return
    }
    this.projectTreeLoadingState = LoadingState.INIT_LOADING
    await this.resposity.fetchProjectType().then((result: ProjectTreeResponse) => {
      if (result.data != null && result.data.length > 0) {
        Logger.i(`fetchProjectType success: ${JSON.stringify(result)}`)
        this.projectTreeData.loadData(result.data)
        this.projectTreeLoadingState = LoadingState.SUCCESS
      } else {
        Logger.i(`fetchProjectType faliure: ${JSON.stringify(result)}`)
        this.projectTreeLoadingState = LoadingState.ERROR
      }
    }).catch(() => {
      Logger.i("fetchProjectType error")
      this.projectTreeLoadingState = LoadingState.ERROR
    })
  }

  private checkLoading(state: LoadingState): boolean {
    return state == LoadingState.INIT_LOADING || state == LoadingState.MORE_LOADING
  }

}