export interface Schedule {
  title: string;
  start: Date;
  end: Date;
  details: string;
  location: string;
  startString: string;
  endString: string;
}

export class CalndarSchedule {
  title: string;
  start: Date;
  end: Date;
  details: string;
  location: string;

  constructor(params: {
    title: string;
    startDate: string;
    startTime: string;
    endDate: string;
    endTime: string;
    details: string;
    location: string;
  }) {
    this.title = params.title;
    this.start = parseDate(params.startDate, params.startTime);
    this.end = parseDate(params.endDate, params.endTime);
    this.details = params.details;
    this.location = params.location;
  }

  get startString(): string {
    return `${formatDate(this.start)} ${formatTime(this.start)}`;
  }

  get endString(): string {
    return `${formatDate(this.end)} ${formatTime(this.end)}`;
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

function formatDate(date: Date): string {
  const year = date.getFullYear();
  const month = ("0" + (date.getMonth() + 1)).slice(-2);
  const day = ("0" + date.getDate()).slice(-2);
  return `${year}年${month}月${day}日`;
}

function formatTime(date: Date): string {
  const hour = ("0" + date.getHours()).slice(-2);
  const minute = ("0" + date.getMinutes()).slice(-2);
  return `${hour}時${minute}分`;
}
