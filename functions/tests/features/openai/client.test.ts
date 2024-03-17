/* eslint-disable max-len */
import { describe, test } from "@jest/globals";
import { ChatCompletion } from "openai/resources/chat/completions";
import { askToExtractSchedule } from "../../../src/features/openai/client";

describe("askToExtractSchedule", () => {
  test.skip("OpenAIのAPIに本当に問い合わせて、レスポンスを確認する", async () => {
    const text = `\
    ＜明治神宮外苑＞日本最大級「東京クリスマスマーケット2023」グリューワインや欧風料理、雑貨も
    
    9年目を迎える「東京クリスマスマーケット」は、2022年開催時に日比谷公園にて25万人の来場者を集める等、日本最大級の人気クリスマスイベントだ。日比谷公園のリニューアルに伴い、2023年はいちょう並木の参道でも知られる神宮外苑の絵画館前にて開催。飲食店25店舗、雑貨30店舗が集結し、本場ドイルのクリスマスマーケットを楽しむグルメのほか、クリスマス雑貨の販売や、音楽団の演奏などステージパフォーマンスも行われる。
    
    ■東京クリスマスマーケット2023
    開催期間：2023年11月23日(木)～12月25日(月) 33日間(予定)
    初日16:00～21:30／全日11:00～21:30 ※ラストオーダー各日21:00
    会場：明治神宮外苑 聖徳記念絵画館前・総合球技場\
    `;

    const response: ChatCompletion = await askToExtractSchedule(text);
    const contentJson = response.choices[0].message.content as string;
    console.log(contentJson);
    // {
    //   "title": "東京クリスマスマーケット2023",
    //   "start_date": "20231123",
    //   "start_time": "160000",
    //   "end_date": "20231225",
    //   "end_time": "213000",
    //   "details": "日本最大級のクリスマスマーケット。飲食店25店舗、雑貨30店舗が集結し、本場ドイツのクリスマスマーケットを楽しむグルメのほか、クリスマス雑貨の販売や、音楽団の演奏などステージパフォーマンスも行われる。%0Ahttps://www.tokyochristmasmarket.com",
    //   "location": "明治神宮外苑 聖徳記念絵画館前・総合球技場"
    // }
  });
});
