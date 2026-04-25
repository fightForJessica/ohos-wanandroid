import { ArticalResponse } from "../model/ArticalData";
import axios from "@ohos/axios";
import { BannerResponse } from "../model/BannerData";

const BASE_URL = "https://wanandroid.com"

export class MainResposity {

  private instance = axios.create({
    baseURL: BASE_URL,
    timeout: 5000
  })

  async get<T>(url: string, params?: object): Promise<T> {
    return (await this.instance.get(url, { params })).data
  }

  async post<T>(url: string, params?: object): Promise<T> {
    return (await this.instance.post(url, params)).data
  }

  async fetchBannerData(): Promise<BannerResponse> {
    let url = "banner/json"
    return await this.get<BannerResponse>(url)
  }

  async fetchArticalData(page: number): Promise<ArticalResponse> {
    let url = "article/list/" + page + "/json"
    return await this.get<ArticalResponse>(url)
	}

}