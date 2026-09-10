<script>
import { layoutComputed, layoutMethods } from "@/state/helpers";

import Vertical from "./vertical";
import Horizontal from "./horizontal";
import TwoColumns from "./twocolumn";

export default {
    name: "MainLayout",
    components: {
        Vertical,
        Horizontal,
        TwoColumns
    },
    data() {
        return {};
    },
    computed: {
        ...layoutComputed,
    },
    methods: {
        ...layoutMethods
    },
    mounted() {
        // FORÇA A INICIALIZAÇÃO CORRETA DO ESTADO DE LAYOUT VERTICAL NO VUEX
        // Isso sincroniza o JavaScript do menu e destrava a renderização do slot
        if (this.changeLayoutType) {
            this.changeLayoutType({ layoutType: this.layoutType || 'vertical' });
        }
    }
};
</script>

<template>
    <div>
        <Vertical v-if="layoutType === 'vertical' || layoutType === 'semibox'" :layout="layoutType">
            <slot />
        </Vertical>

        <Horizontal v-if="layoutType === 'horizontal'" :layout="layoutType">
            <slot />
        </Horizontal>

        <TwoColumns v-if="layoutType === 'twocolumn'" :layout="layoutType">
            <slot />
        </TwoColumns>
    </div>
</template>
