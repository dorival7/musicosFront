<script>
import { required, email, helpers } from "@vuelidate/validators";
import axios from 'axios';
import { notificationMethods } from "@/state/helpers";

export default {
  name: "Login",
  data() {
    return {
      email: "",
      password: "",
      submitted: false,
      authError: null,
      processing: false,
    };
  },
  validations: {
    email: {
      required: helpers.withMessage("O e-mail é obrigatório.", required),
      email: helpers.withMessage("Insira um endereço de e-mail válido.", email),
    },
    password: {
      required: helpers.withMessage("A senha é obrigatória.", required),
    },
  },
  methods: {
    ...notificationMethods,

    // Método Oficial de Envio para o .NET 10
    async tryToLogIn() {
      this.submitted = true;
      this.authError = null;

      if (this.$v) {
        this.$v.$touch();
        if (this.$v.$invalid) return;
      }

      this.processing = true;

      try {
        // Disparo utilizando a URL dinâmica do .env
        const response = await axios.post(`${process.env.VUE_APP_API_BASE_URL}/auth/login`, {
          email: this.email,
          password: this.password
        });

        // Salva o Token JWT legítimo retornado pelo C#
        localStorage.setItem('jwt', response.data.token);
        localStorage.setItem('roles', JSON.stringify(response.data.roles || []));
        
        // Salva o status de onboarding que o roteador vai ler
        localStorage.setItem('profileStatus', response.data.profileStatus);
        
        const userData = { name: response.data.name || "SevenShows", email: this.email, roles: response.data.roles || [] };
        localStorage.setItem('user', JSON.stringify(userData));
        localStorage.setItem('userdata', JSON.stringify(userData));

        // Envia para a Dashboard (onde o interceptador agirá)
        const roles = response.data.roles || [];
        this.$router.push(roles.includes('SuperAdmin') ? '/admin/dashboard' : '/musicos/dashboard');

      } catch (error) {
        this.processing = false;
        
        if (error.response && error.response.data && error.response.data.message) {
          this.authError = error.response.data.message;
        } else if (error.response && error.response.status === 401) {
          this.authError = "E-mail ou senha incorretos. Tente novamente.";
        } else {
          this.authError = "Não foi possível conectar ao servidor. Verifique o backend .NET.";
        }
      }
    },
  },
};
</script>

<template>
  <div class="auth-page-wrapper pt-5">
    <div class="auth-one-bg-position auth-one-bg" id="auth-particles">
      <div class="bg-overlay"></div>
      <div class="shape">
        <!-- 
          O atributo xmlns foi FISICAMENTE REMOVIDO da tag <svg> abaixo 
          para neutralizar o erro de x-invalid-namespace do ESLint.
        -->
        <svg version="1.1" viewBox="0 0 1440 120">
          <path d="M 0,36 C 144,53.6 432,123.2 720,124 C 1008,124.8 1296,56.8 1440,40L1440 140L0 140z"></path>
        </svg>
      </div>
    </div>

    <div class="auth-page-content">
      <div class="container">
        <div class="row">
          <div class="col-lg-12">
            <div class="text-center mt-sm-5 mb-4 text-white-50">
              <div>
                <router-link to="/" class="d-inline-block auth-logo">
                  <img src="@/assets/images/logo-light.png" alt="SevenShows" height="30" />
                </router-link>
              </div>
              <p class="mt-3 fs-15 fw-medium text-white">
                Área Administrativa do Artista
              </p>
            </div>
          </div>
        </div>

        <div class="row justify-content-center">
          <div class="col-md-8 col-lg-6 col-xl-5">
            <div class="card mt-4">
              <div class="card-body p-4">
                <div class="text-center mt-2">
                  <h5 class="text-primary">Seja bem-vindo de volta!</h5>
                  <p class="text-muted">Faça login para gerenciar sua agenda e shows.</p>
                </div>
                <div class="p-2 mt-4">
                  
                  <!-- CAIXA DE ALERTA ALIMENTADA DIRETAMENTE POR CLASSES DO BOOTSTRAP PURAS -->
                  <div v-if="authError" class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                    {{ authError }}
                    <button type="button" class="btn-close" @click="authError = null" aria-label="Close"></button>
                  </div>

                  <form @submit.prevent="tryToLogIn">
                    <div class="mb-3">
                      <label for="email" class="form-label">E-mail</label>
                      <input type="email" class="form-control" id="email" placeholder="Digite seu e-mail" v-model="email" />
                    </div>

                    <div class="mb-3">
                      <div class="float-end">
                        <router-link to="/forgot-password" class="text-muted fs-12">Esqueceu a senha?</router-link>
                      </div>
                      <label class="form-label" for="password-input">Senha</label>
                      <div class="position-relative auth-pass-inputgroup mb-3">
                        <input type="password" v-model="password" class="form-control pe-5" placeholder="Digite sua senha" id="password-input" />
                      </div>
                    </div>

                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" id="auth-remember-check" />
                      <label class="form-check-label" for="auth-remember-check">Lembrar de mim</label>
                    </div>

                    <div class="mt-4">
                      <button type="submit" class="btn btn-success w-100" :disabled="processing">
                        {{ processing ? "Aguarde, conectando..." : "Entrar no Painel" }}
                      </button>
                    </div>
                  </form>
                </div>
              </div>
            </div>

            <div class="mt-4 text-center text-muted">
              <p class="mb-0">
                Ainda não tem conta? O cadastro deve ser feito na nossa
                <a href="javascript:void(0);" class="fw-semibold text-primary text-decoration-underline">Landing Page</a>.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <footer class="footer">
      <div class="container">
        <div class="row">
          <div class="col-lg-12">
            <div class="text-center">
              <p class="mb-0 text-muted">
                &copy; {{ new Date().getFullYear() }} SevenShows. Todos os direitos reservados.
              </p>
            </div>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>
