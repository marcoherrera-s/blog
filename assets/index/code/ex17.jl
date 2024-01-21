# This file was generated, do not modify it. # hide
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