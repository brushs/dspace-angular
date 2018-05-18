import { isNotEmpty } from '../shared/empty.util';
import { URLCombiner } from '../core/url-combiner/url-combiner';
import 'core-js/fn/object/entries';

export enum ViewMode {
  List = 'list',
  Grid = 'grid',
  Detail = 'detail'
}

export class SearchOptions {
  view?: ViewMode = ViewMode.List;
  configuration?: string;
  scope?: string;
  query?: string;
  filters?: any;

  toRestUrl(url: string, args: string[] = []): string {

    if (isNotEmpty(this.configuration)) {
      args.push(`configuration=${this.configuration}`);
    }

    if (isNotEmpty(this.query)) {
      args.push(`query=${this.query}`);
    }

    if (isNotEmpty(this.scope)) {
      args.push(`scope=${this.scope}`);
    }
    if (isNotEmpty(this.filters)) {
      Object.entries(this.filters).forEach(([key, values]) => {
        values.forEach((value) => args.push(`${key}=${value},equals`));
      });
    }
    if (isNotEmpty(args)) {
      url = new URLCombiner(url, `?${args.join('&')}`).toString();
    }
    return url;
  }
}
