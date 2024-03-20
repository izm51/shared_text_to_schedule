import { describe, test, expect } from "@jest/globals";
import {
  CalendarScheduleBuildError,
  CalndarSchedule,
  Schedule,
} from "../../../src/features/openai/domain";

describe("CalenderSchedule domain", () => {
  describe(".fromJson", () => {
    test("openaiのAPIレスポンスからインスタンスを作成できる", () => {
      const contentJson = `\
        {
          "title": "東京クリスマスマーケット2023",
          "start_date": "20231123",
          "start_time": "160000",
          "end_date": "20231225",
          "end_time": "213000",
          "details": "日本最大級のクリスマスマーケット。飲食店25店舗、雑貨30店舗が集結。音楽団の演奏などステージパフォーマンスも。",
          "location": "明治神宮外苑 聖徳記念絵画館前・総合球技場"
        }`;
      const calendarSchedule = CalndarSchedule.fromJSON(contentJson);

      expect(calendarSchedule.title).toBe("東京クリスマスマーケット2023");
      expect(calendarSchedule.start).toEqual(
        new Date("2023-11-23T16:00:00+09:00")
      );
      expect(calendarSchedule.end).toEqual(
        new Date("2023-12-25T21:30:00+09:00")
      );
      expect(calendarSchedule.details).toBe(
        "日本最大級のクリスマスマーケット。飲食店25店舗、雑貨30店舗が集結。音楽団の演奏などステージパフォーマンスも。"
      );
      expect(calendarSchedule.location).toBe(
        "明治神宮外苑 聖徳記念絵画館前・総合球技場"
      );
    });

    test("jsonに不足している項目がある場合、エラーが発生する", () => {
      const contentJson = `\
        {
          "title": "東京クリスマスマーケット2023",
          "start_date": "20231123",
          "start_time": "160000",
          "end_date": "20231225",
          "end_time": "213000",
          "details": "日本最大級のクリスマスマーケット。飲食店25店舗、雑貨30店舗が集結。音楽団の演奏などステージパフォーマンスも。"
        }`;
      expect(() => CalndarSchedule.fromJSON(contentJson)).toThrowError(
        new CalendarScheduleBuildError("JSON does not have location")
      );
    });

    test("jsonの日付が不正な場合、エラーが発生する", () => {
      const contentJson = `\
        {
          "title": "東京クリスマスマーケット2023",
          "start_date": "2023123",
          "start_time": "160000",
          "end_date": "20231225",
          "end_time": "213000",
          "details": "日本最大級のクリスマスマーケット。飲食店25店舗、雑貨30店舗が集結。音楽団の演奏などステージパフォーマンスも。",
          "location": "明治神宮外苑 聖徳記念絵画館前・総合球技場"
        }`;
      expect(() => CalndarSchedule.fromJSON(contentJson)).toThrowError(
        new CalendarScheduleBuildError(
          "JSON has invalid start_date: 2023123 must be YYYYMMDD"
        )
      );
    });

    test("jsonの時刻が不正な場合、エラーが発生する", () => {
      const contentJson = `\
        {
          "title": "東京クリスマスマーケット2023",
          "start_date": "20231123",
          "start_time": "16000",
          "end_date": "20231225",
          "end_time": "213000",
          "details": "日本最大級のクリスマスマーケット。飲食店25店舗、雑貨30店舗が集結。音楽団の演奏などステージパフォーマンスも。",
          "location": "明治神宮外苑 聖徳記念絵画館前・総合球技場"
        }`;
      expect(() => CalndarSchedule.fromJSON(contentJson)).toThrowError(
        new CalendarScheduleBuildError(
          "JSON has invalid start_time: 16000 must be hhmmss"
        )
      );
    });
  });

  describe("constructor", () => {
    test("開始日時が終了日時よりも後の場合、エラーが発生する", () => {
      expect(
        () =>
          new CalndarSchedule({
            title: "東京クリスマスマーケット2023",
            startDate: "20231225",
            startTime: "213000",
            endDate: "20231123",
            endTime: "160000",
            details:
              "日本最大級のクリスマスマーケット。飲食店25店舗、雑貨30店舗が集結。音楽団の演奏などステージパフォーマンスも。",
            location: "明治神宮外苑 聖徳記念絵画館前・総合球技場",
          })
      ).toThrowError(
        new CalendarScheduleBuildError(
          "Invalid start and end: 20231225T213000 > 20231123T160000"
        )
      );
    });
  });

  describe("インスタンスについて", () => {
    test("日時がparseできる", () => {
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

      expect(calendarSchedule.startString).toBe("2023年11月23日 16時00分");
      expect(calendarSchedule.endString).toBe("2023年12月25日 21時30分");
    });
  });
});
