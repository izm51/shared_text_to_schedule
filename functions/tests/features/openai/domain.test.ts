import { describe, test, expect } from "@jest/globals";
import { CalndarSchedule, Schedule } from "../../../src/features/openai/domain";

describe("constract CalndarSchedule", () => {
  test("日時がparseされてインスタンスが作成される", () => {
    const calendarSchedule: Schedule = new CalndarSchedule({
      title: "東京クリスマスマーケット2023",
      startDate: "20231123",
      startTime: "160000",
      endDate: "20231225",
      endTime: "213000",
      details:
        "日本最大級のクリスマスマーケット。飲食店25店舗、雑貨30店舗が集結。音楽団の演奏などステージパフォーマンスも。",
      location: "明治神宮外苑 聖徳記念絵画館前・総合球技場",
    });

    expect(calendarSchedule.title).toBe("東京クリスマスマーケット2023");
    expect(calendarSchedule.startString).toBe("2023年11月23日 16時00分");
    expect(calendarSchedule.endString).toBe("2023年12月25日 21時30分");
  });
});
