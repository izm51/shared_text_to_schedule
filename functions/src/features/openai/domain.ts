export class CalendarScheduleBuildError extends Error {
  static {
    this.prototype.name = "CalendarScheduleBuildError";
  }
}

export class CalndarSchedule {
  title: string;
  startDate: string;
  startTime: string;
  endDate: string;
  endTime: string;
  details: string;
  location: string;

  static fromJSON(json: string): CalndarSchedule {
    const obj = JSON.parse(json);

    const requiredKeys = [
      "title",
      "start_date",
      "start_time",
      "end_date",
      "end_time",
      "details",
      "location",
    ];
    for (const key of requiredKeys) {
      if (obj[key] === undefined) {
        throw new CalendarScheduleBuildError(`JSON does not have ${key}`);
      }
    }

    const dateKeys = ["start_date", "end_date"];
    for (const key of dateKeys) {
      if (obj[key].length !== 8) {
        throw new CalendarScheduleBuildError(
          `JSON has invalid ${key}: ${obj[key]} must be YYYYMMDD`
        );
      }
    }

    const timeKeys = ["start_time", "end_time"];
    for (const key of timeKeys) {
      if (obj[key].length !== 6) {
        throw new CalendarScheduleBuildError(
          `JSON has invalid ${key}: ${obj[key]} must be hhmmss`
        );
      }
    }

    return new CalndarSchedule({
      title: obj.title,
      startDate: obj.start_date,
      startTime: obj.start_time,
      endDate: obj.end_date,
      endTime: obj.end_time,
      details: obj.details,
      location: obj.location,
    });
  }

  constructor(params: {
    title: string;
    startDate: string;
    startTime: string;
    endDate: string;
    endTime: string;
    details: string;
    location: string;
  }) {
    const start = parseDate(params.startDate, params.startTime);
    const end = parseDate(params.endDate, params.endTime);

    if (start > end) {
      throw new CalendarScheduleBuildError(
        `Invalid start and end: ${params.startDate}T${params.startTime} > ${params.endDate}T${params.endTime}`
      );
    }

    this.title = params.title;
    this.startDate = params.startDate;
    this.startTime = params.startTime;
    this.endDate = params.endDate;
    this.endTime = params.endTime;
    this.details = params.details;
    this.location = params.location;
  }
}

function parseDate(date: string, time: string): Date {
  const year = parseInt(date.slice(0, 4));
  const monthIndex = parseInt(date.slice(4, 6)) - 1;
  const day = parseInt(date.slice(6, 8));
  const hour = parseInt(time.slice(0, 2));
  const minute = parseInt(time.slice(2, 4));
  const second = parseInt(time.slice(4, 6));
  return new Date(year, monthIndex, day, hour, minute, second);
}
