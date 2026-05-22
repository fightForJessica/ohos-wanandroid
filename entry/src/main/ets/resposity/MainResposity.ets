import { ArticalResponse } from "../model/ArticalData";
import { BannerResponse } from "../model/BannerData";
import BaseResposity from "./BaseResposity";

export class MainResposity extends BaseResposity {

  async fetchBannerData(): Promise<BannerResponse> {
    let url = "banner/json"
    return await this.get<BannerResponse>(url)
  }

  async fetchArticalData(page: number): Promise<ArticalResponse> {
    let url = `article/list/${page}/json`
    return await this.get<ArticalResponse>(url)
	}

}