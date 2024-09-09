import numpy as np

def simpson_rule_1_3(f, a, b, n): #el normal para ecuaciones cuaraticas
    """
                    Aproxima la integral de la función f en el intervalo [a, b] usando el Método de Simpson 1/3.

                    :param f: La función que queremos integrar.
                    :param a: El límite inferior del intervalo.
                    :param b: El límite superior del intervalo.
                    :param n: El número de subintervalos (debe ser par).
                    :return: La aproximación de la integral de f en [a, b].
    """
    if n % 2 != 0:
        raise ValueError("El número de subintervalos n debe ser par.")
    
    h = (b - a) / n
    x = np.linspace(a, b, n + 1)
    y = f(x)
    
    integral = y[0] + y[-1]
    integral += 4 * np.sum(y[1:-1:2])
    integral += 2 * np.sum(y[2:-2:2])
    integral *= h / 3
    
    return integral

def simpson_rule_3_8(f, a, b, n): #para ecuaciones cubicas
    """
                    Aproxima la integral de la función f en el intervalo [a, b] usando el Método de Simpson 3/8.

                    :param f: La función que queremos integrar.
                    :param a: El límite inferior del intervalo.
                    :param b: El límite superior del intervalo.
                    :param n: El número de subintervalos (debe ser divisible por 3).
                    :return: La aproximación de la integral de f en [a, b].
    """
    if n % 3 != 0:
        raise ValueError("El número de subintervalos n debe ser divisible por 3.")
    
    h = (b - a) / n
    integral = 0
    for i in range(0, n, 3):
        x0 = a + i * h
        x1 = x0 + h / 3
        x2 = x0 + 2 * h / 3
        x3 = x0 + h
        integral += (3 * h / 8) * (f(x0) + 3 * f(x1) + 3 * f(x2) + f(x3))
    
    return integral

# Ejemplo de uso

def f(x):
    return x**2  # Función a integrar

# Límite inferior y superior
a = 0
b = 1

# Número de subintervalos (debe ser par para 1/3 y divisible por 3 para 3/8)
n_1_3 = 10  # Ejemplo para Simpson 1/3
n_3_8 = 9   # Ejemplo para Simpson 3/8 (divisible por 3)

# Calcular la integral usando Simpson 1/3
resultado_1_3 = simpson_rule_1_3(f, a, b, n_1_3)
print(f"La aproximación de la integral usando Simpson 1/3 es: {resultado_1_3}")

# Calcular la integral usando Simpson 3/8
resultado_3_8 = simpson_rule_3_8(f, a, b, n_3_8)
print(f"La aproximación de la integral usando Simpson 3/8 es: {resultado_3_8}")
