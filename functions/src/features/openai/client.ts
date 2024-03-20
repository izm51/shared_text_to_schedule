import OpenAI from "openai";
import "dotenv/config";

// MEMO: デフォでmockを使っている。ただし、テスト側でも関数をMockするようにする。
// ローカルとテストで同じ設定を使うので、ローカルでモック使ってないときにテストでクレジット消費してしまう危険がある。
// TODO: https://zenn.dev/ncdc/articles/jest-environment
const openaiUseMock = (process.env.OPENAI_USE_MOCK || "true") === "true";

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

const systemMessage = `\
ユーザーから与えられた文章から、日程情報を抽出してください。
出力は次のようなJSON形式としてください。

{
  title: string, // 予定のタイトル
  start_date: YYYYMMDD, // 開始日
  start_time: hhmmss, // 開始時刻
  end_date: YYYYMMDD, // 終了日
  end_time: hhmmss, // 終了時刻
  details: string, // 100文字以内で要約。URLは文字数に関わらず優先的に残す。改行コード"%0A"を用いて適度に改行する。
  location: string // 開催場所
}

注意:
* 出力にはJSON形式以外の内容を含まないでください。
* 主催者の名称が分かればtitleに含めてください
* locationは位置が特定しやすいようにしてください
* 終了日時が不明な場合は開始日時から2時間後にしてください。\
`;

const mockResponse: OpenAI.Chat.Completions.ChatCompletion = {
  id: "chatcmpl-8dfaITYvUkRvyN3oGyyGH7UFGSrDT",
  object: "chat.completion",
  created: 1704465334,
  model: "gpt-3.5-turbo-1106",
  choices: [
    {
      index: 0,
      message: {
        role: "assistant",
        /* eslint-disable max-len */
        content: `\
        {
          "title": "東京クリスマスマーケット2023",
          "start_date": "20231123",
          "start_time": "160000",
          "end_date": "20231225",
          "end_time": "213000",
          "details": "日本最大級のクリスマスマーケット。飲食店25店舗、雑貨30店舗が集結。音楽団の演奏などステージパフォーマンスも。",
          "location": "明治神宮外苑 聖徳記念絵画館前・総合球技場"
        }`,
        /* eslint-enable max-len */
      },
      logprobs: null,
      finish_reason: "stop",
    },
  ],
  usage: { prompt_tokens: 688, completion_tokens: 167, total_tokens: 855 },
  system_fingerprint: "fp_99cc374e39",
};

export async function askToExtractSchedule(
  text: string
): Promise<OpenAI.Chat.Completions.ChatCompletion> {
  let chatCompletion: OpenAI.Chat.ChatCompletion;
  if (!openaiUseMock) {
    chatCompletion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo-1106",
      response_format: { type: "json_object" },
      messages: [
        { role: "system", content: systemMessage },
        { role: "user", content: text },
      ],
      temperature: 0.2,
      max_tokens: 256,
    });
  } else {
    chatCompletion = mockResponse;
  }

  return chatCompletion;
}
