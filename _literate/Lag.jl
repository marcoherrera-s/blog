using Pkg 
Pkg.activate("_literate/Project.toml")

# # Problema

# A veces, al resolver problemas de física, algunas de las cosas que más me han molestado es: una, sufrir por la _talacha_ y dos; no saber qué estoy haciendo.

# A ver, como físicos, siempre nos vamos a enfrentar a la talacha, a veces es el pan de cada día. No hay manera de terminar con ella, pero sí de hacerla más soportable.

# Entonces, lo que haremos hoy, será resolver uno de esos problemas que requeriría un buen arrastre del lápiz, pero sin usar el lapiz.

# El problema es el siguiente:


# 1. El punto A de una barra \( AB \) se puede mover sin fricción a lo largo de una línea horizontal (eje \( x \)). La barra es homogénea de masa \( m \) y longitud \( l \). Se mueve en un plano vertical donde puede rotar libremente alrededor de A. Sobre A se ejerce una fuerza periódica en el eje horizontal $F_x = \frac{1}{3} mg \cos(\omega t) $, donde  $\omega^2 = \frac{g}{l}$. Encontrar las ecuaciones de movimiento y resolverlas asumiendo que el ángulo $\varphi$ y la velocidad angular $\dot{\varphi}$ son pequeños. Usar las condiciones iniciales $x(0) = \dot{x}(0) = 0 $ y $ \varphi(0) = \dot{\varphi}(0) $.


# \fig{/_assets/problema.png}

# Entonces, lo primero que haremos será importar las paqueterías que vamos a usar.

using SymPy, DifferentialEquations, Plots


# Ahora, lo primero que haremos será definir nuestras variables y nuestras funciones, para entender rápidamente cuáles serán variables y cuáles funciones, primero hay que tener una idea clara de los grados de libertad de nuestro sistema y de las coordenadas canónicas, entonces, observando el sistema podemos concluir que las coordenadas canónicas serán la distancia en $x$ y el ángulo $\theta$ en el cual está rotando la barra.

@syms m g y_cm x_cm l t 
θ = SymFunction("θ")(t)
x = SymFunction("x")(t)

# a 
xdot = diff(x, t)
xddot = diff(xdot, t)
thetadot = diff(θ, t)
thetaddot = diff(thetadot, t)



x_cm = x + l//2 * sin(θ)
y_cm = l//2*cos(θ)
println(y_cm)

# Derivamos nuestras variables haciendo:


x_cmd = diff(x_cm, t)
y_cmd = diff(y_cm, t)
println(y_cmd)


# Y obtendremos:


# $\frac{l \cos{\left(θ{\left(t \right)} \right)} \frac{d}{d t} θ{\left(t \right)}}{2} + \frac{d}{d t} x{\left(t \right)}$

# El siguiente paso es obtener la energía cinética, este sería un proceso un poco talachudo porque implica elevar al cuadrado los términos y luego sumarlos, hagamos simplemente:


T_cm = 1//2 * m * (x_cmd^2 + y_cmd^2)
@show T_cm


# $\frac{m \left(\frac{l^{2} \sin^{2}{\left(θ{\left(t \right)} \right)} \left(\frac{d}{d t} θ{\left(t \right)}\right)^{2}}{4} + \left(\frac{l \cos{\left(θ{\left(t \right)} \right)} \frac{d}{d t} θ{\left(t \right)}}{2} + \frac{d}{d t} x{\left(t \right)}\right)^{2}\right)}{2}$

# Como podemos ver, aún no está tan bien, personas inteligentes como nosotros hubieramos usado la identidad $\sin^2 x + \cos^2 x = 1$

# Eso no es problema, podemos hacer simplemente:


T_cm = simplify(expand(T_cm));


# $\frac{m \left(l^{2} \left(\frac{d}{d t} θ{\left(t \right)}\right)^{2} + 4 l \cos{\left(θ{\left(t \right)} \right)} \frac{d}{d t} x{\left(t \right)} \frac{d}{d t} θ{\left(t \right)} + 4 \left(\frac{d}{d t} x{\left(t \right)}\right)^{2}\right)}{8}$



I = sympy.diag(0, m*l^2 // 12, m*l^2 // 12)
ω = Matrix([0 0 diff(θ, t)]) 
T_rot = (1//2)*ω*I*ω.T
T_rot = T_rot[1];


# $\frac{l^{2} m \left(\frac{d}{d t} θ{\left(t \right)}\right)^{2}}{24}$


T = T_cm + T_rot;


# $\frac{l^{2} m \left(\frac{d}{d t} θ{\left(t \right)}\right)^{2}}{24} + \frac{m \left(l^{2} \left(\frac{d}{d t} θ{\left(t \right)}\right)^{2} + 4 l \cos{\left(θ{\left(t \right)} \right)} \frac{d}{d t} x{\left(t \right)} \frac{d}{d t} θ{\left(t \right)} + 4 \left(\frac{d}{d t} x{\left(t \right)}\right)^{2}\right)}{8}$




T = expand(T);


# $\frac{l^{2} m \left(\frac{d}{d t} θ{\left(t \right)}\right)^{2}}{6} + \frac{l m \cos{\left(θ{\left(t \right)} \right)} \frac{d}{d t} x{\left(t \right)} \frac{d}{d t} θ{\left(t \right)}}{2} + \frac{m \left(\frac{d}{d t} x{\left(t \right)}\right)^{2}}{2}$


@syms Ω



U = (m*g*l//2)*cos(θ) - integrate(1//3 * m*g*cos(Ω*t), x)
U = simplify(U);


# $\frac{g m \left(3 l \cos{\left(θ{\left(t \right)} \right)} - 2 x{\left(t \right)} \cos{\left(t Ω \right)}\right)}{6}$

L = T - U;


# $- \frac{g m \left(3 l \cos{\left(θ{\left(t \right)} \right)} - 2 x{\left(t \right)} \cos{\left(t Ω \right)}\right)}{6} + \frac{l^{2} m \left(\frac{d}{d t} θ{\left(t \right)}\right)^{2}}{6} + \frac{l m \cos{\left(θ{\left(t \right)} \right)} \frac{d}{d t} x{\left(t \right)} \frac{d}{d t} θ{\left(t \right)}}{2} + \frac{m \left(\frac{d}{d t} x{\left(t \right)}\right)^{2}}{2}$




ELX = diff(diff(L, xdot), t) - diff(L, x);


# $- \frac{g m \cos{\left(t Ω \right)}}{3} - \frac{l m \sin{\left(θ{\left(t \right)} \right)} \left(\frac{d}{d t} θ{\left(t \right)}\right)^{2}}{2} + \frac{l m \cos{\left(θ{\left(t \right)} \right)} \frac{d^{2}}{d t^{2}} θ{\left(t \right)}}{2} + m \frac{d^{2}}{d t^{2}} x{\left(t \right)}$



ELθ = diff(diff(L, thetadot), t) - diff(L, θ);


# $- \frac{g l m \sin{\left(θ{\left(t \right)} \right)}}{2} + \frac{l^{2} m \frac{d^{2}}{d t^{2}} θ{\left(t \right)}}{3} + \frac{l m \cos{\left(θ{\left(t \right)} \right)} \frac{d^{2}}{d t^{2}} x{\left(t \right)}}{2}$



sol_1 = solve(ELX, xddot)

sol_1[1];

# $\frac{g \cos{\left(t Ω \right)}}{3} + \frac{l \sin{\left(θ{\left(t \right)} \right)} \left(\frac{d}{d t} θ{\left(t \right)}\right)^{2}}{2} - \frac{l \cos{\left(θ{\left(t \right)} \right)} \frac{d^{2}}{d t^{2}} θ{\left(t \right)}}{2}$




sol_2 = solve(ELθ, thetaddot)
sol_2[1];



# $\frac{3 \left(g \sin{\left(θ{\left(t \right)} \right)} - \cos{\left(θ{\left(t \right)} \right)} \frac{d^{2}}{d t^{2}} x{\left(t \right)}\right)}{2 l}$




params = (9.81, 1.0, sqrt(9.81/1.0))
tspan = (0.0, 10.0)



function second_order_system(ddu, du, u, p, t)
    g, l, Ω = p


    ddu[1] = g * cos(t * Ω) / 3 + l * sin(u[2]) * du[2]^2 / 2 - l * cos(u[2]) * ddu[2] / 2
    ddu[2] = 3 * (g * sin(u[2]) - cos(u[2]) * ddu[1]) / (2 * l)
end



u0 = [0.0, 0.0]
du0 = [0.0, 0.0]



prob = SecondOrderODEProblem(second_order_system, du0, u0, tspan, params)


