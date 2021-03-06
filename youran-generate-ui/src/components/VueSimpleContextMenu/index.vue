<template>
  <div>
    <ul :class="['vue-simple-context-menu',menuClassName]"
        v-click-outside="onClickOutside">
      <li
        v-for="(option, index) in options"
        :key="index"
        @click="optionClicked(option)"
        class="vue-simple-context-menu__item"
        :class="option.class">
        <span v-if="showIcon" style="min-width: 20px;">
          <svg-icon v-if="option.svgIcon" :className="option.svgClassName"
                    :iconClass="option.svgIcon"></svg-icon>
        </span>
        {{option.name}}
      </li>
    </ul>
  </div>
</template>

<script>
import Vue from 'vue'
import vClickOutside from 'v-click-outside'
Vue.use(vClickOutside)
export default {
  name: 'VueSimpleContextMenu',
  props: {
    showIcon: {
      type: Boolean,
      default: false
    },
    menuClassName: {
      type: String
    },
    options: {
      type: Array,
      required: true
    }
  },
  data () {
    return {
      item: null,
      menuWidth: null,
      menuHeight: null
    }
  },
  methods: {
    showMenu (event, item) {
      this.item = item
      const menu = this.$el.firstChild
      if (!menu) {
        return
      }
      if (!this.menuWidth || !this.menuHeight) {
        menu.style.visibility = 'hidden'
        menu.style.display = 'block'
        this.menuWidth = menu.offsetWidth
        this.menuHeight = menu.offsetHeight
        menu.removeAttribute('style')
      }
      if ((this.menuWidth + event.pageX) >= window.innerWidth) {
        menu.style.left = (event.pageX - this.menuWidth + 2) + 'px'
      } else {
        menu.style.left = (event.pageX - 2) + 'px'
      }
      if ((this.menuHeight + event.pageY) >= window.innerHeight) {
        menu.style.top = (event.pageY - this.menuHeight + 2) + 'px'
      } else {
        menu.style.top = (event.pageY - 2) + 'px'
      }
      menu.classList.add('vue-simple-context-menu--active')
    },
    hideContextMenu () {
      const menu = this.$el.firstChild
      if (menu) {
        menu.classList.remove('vue-simple-context-menu--active')
      }
    },
    onClickOutside () {
      this.hideContextMenu()
    },
    optionClicked (option) {
      this.hideContextMenu()
      this.$emit('option-clicked', {
        item: this.item,
        option: option
      })
    }
  }
}
</script>

<style lang="scss">
  $light-grey: #ecf0f1;
  $grey: darken($light-grey, 15%);
  $blue: #007aff;
  $white: #fff;
  $black: #333;
  .vue-simple-context-menu {
    top: 0;
    left: 0;
    margin: 0;
    padding: 0;
    display: none;
    list-style: none;
    position: absolute;
    z-index: 1000000;
    background-color: $light-grey;
    border-bottom-width: 0px;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen",
    "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
    sans-serif;
    box-shadow: 0 3px 6px 0 rgba($black, 0.2);
    border-radius: 4px;
    &--active {
      display: block;
    }
    &__item {
      display: flex;
      color: $black;
      cursor: pointer;
      padding: 3px 10px 3px 5px;
      font-size: 12px;
      align-items: center;
      &:hover {
        background-color: $blue;
        color: $white;
      }
    }
    // Have to use the element so we can make use of `first-of-type` and
    // `last-of-type`
    li {
      &:first-of-type {
        margin-top: 4px;
      }
      &:last-of-type {
        margin-bottom: 4px;
      }
    }
  }
</style>
