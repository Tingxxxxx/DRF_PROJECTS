var searchBarVM = new Vue({
  el: '#search-bar',
  delimiters: ['[[', ']]'],
  data: {
    host: host,
    query: '',
    suggestions: [],
    highlight_index: -1,
    show_suggestions: false,
  },
  methods: {
    // 搜尋欄方法
    on_input() {
      if (!this.query) {
        this.load_history();
      } else {
        this.fetch_suggestions();
      }
      this.show_suggestions = true;
    },

    load_history() {
      const key = 'search_history';
      let searchHistory = JSON.parse(localStorage.getItem(key) || '[]');
      this.suggestions = searchHistory.slice(0, 5);
      this.highlight_index = -1;
    },

    fetch_suggestions() {
      axios.get(this.host + 'skus/suggestions/', {
        params: { q: this.query }
      })
      .then(res => {
        this.suggestions = res.data.suggest || [];
        this.highlight_index = -1;
      })
      .catch(err => {
        console.error(err);
        this.suggestions = [];
      });
    },

    move_down() {
      if (this.highlight_index < this.suggestions.length - 1) {
        this.highlight_index++;
        this.scroll_to_highlight();
      }
    },

    move_up() {
      if (this.highlight_index > 0) {
        this.highlight_index--;
        this.scroll_to_highlight();
      }
    },

    select_item() {
      if (this.highlight_index >= 0 && this.highlight_index < this.suggestions.length) {
        this.query = this.suggestions[this.highlight_index];
      }
      this.on_search();
      this.show_suggestions = false;
    },

    select_suggestion(item) {
      this.query = item;
      this.on_search();
      this.show_suggestions = false;
    },

    scroll_to_highlight() {
      this.$nextTick(() => {
        const ul = this.$el.querySelector('.search_suggest');
        const items = ul.querySelectorAll('li');
        if (this.highlight_index >= 0 && items.length > this.highlight_index) {
          const item = items[this.highlight_index];
          const itemTop = item.offsetTop;
          const itemBottom = itemTop + item.offsetHeight;
          const ulScrollTop = ul.scrollTop;
          const ulHeight = ul.clientHeight;

          if (itemTop < ulScrollTop) {
            ul.scrollTop = itemTop;
          } else if (itemBottom > ulScrollTop + ulHeight) {
            ul.scrollTop = itemBottom - ulHeight;
          }
        }
      });
    },

    on_search() {
      if (!this.query.trim()) return;
      const key = 'search_history';
      let history = JSON.parse(localStorage.getItem(key) || '[]');
      history = history.filter(item => item !== this.query);
      history.unshift(this.query);
      if (history.length > 10) history = history.slice(0, 10);
      localStorage.setItem(key, JSON.stringify(history));

      window.location.href = `search.html?q=${encodeURIComponent(this.query.trim())}`;
    },

    handleClickOutside(event) {
      const searchWrap = this.$el.querySelector('.search_wrap');
      if (searchWrap && !searchWrap.contains(event.target)) {
        this.show_suggestions = false;
      }
    },
    // 文本過長截斷並加省略號
    truncate(text, length = 30) {
      if (text.length > length) {
        return text.slice(0, length) + '...';
      }
      return text;
    },
  }
});
