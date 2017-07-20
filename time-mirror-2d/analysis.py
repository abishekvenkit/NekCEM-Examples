#!/usr/bin/env python3
import struct

# Necessary for blitting to work on OSX
import matplotlib
matplotlib.use('TkAgg')

import numpy as np
from scipy.interpolate import BarycentricInterpolator
from scipy.optimize import curve_fit, least_squares
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

NGLLPTS = 9 # number of Gauss-Legendre-Lobatto points


def interpolate_field(xfine, x, field):
    fieldfine = np.empty_like(xfine)
    x = x.reshape(-1, NGLLPTS)
    field = field.reshape(-1, NGLLPTS)
    for seg, fieldseg in zip(x, field):
        xmin, xmax = min(seg), max(seg)
        indices = np.logical_and(xfine >= xmin, xfine <= xmax)
        interp = BarycentricInterpolator(seg, fieldseg)
        fieldfine[indices] = interp(xfine[indices])
    return fieldfine


def load_buf(filename):
    with open(filename, mode='rb') as f:
        content = f.read()
        data = [x for x in struct.iter_unpack("d", content)]
    return np.array(data)


class FittedPlasmon():
    def __init__(self, xdata, tdata, ydata):
        self.xdata, self.tdata, self.ydata = xdata, tdata, ydata
        self.fit()

    def plasmon(self, x, t, A, kspp, omega, phi):
        return A*np.cos(kspp*x - omega*t - phi)

    def residuals(self, params):
        A, kspp, omega, phi = params
        f = self.plasmon(self.xdata, self.tdata, A, kspp, omega, phi)
        return (f - self.ydata).flatten()

    def jac(self, params):
        A, kspp, omega, phi = params
        out = np.empty((self.xdata.size, params.size))
        sinfac = np.sin(kspp*self.xdata - omega*self.tdata - phi)
        sinfac = sinfac.flatten()
        cosfac = np.cos(kspp*self.xdata - omega*self.tdata - phi)
        cosfac = cosfac.flatten()
        out[:,0] = cosfac
        out[:,1] = -A*self.xdata.flatten()*sinfac
        out[:,2] = A*self.tdata.flatten()*sinfac
        out[:,3] = A*sinfac
        return out

    def fit(self):
        # Used an initial amplitude guess of 1 for the backwards
        # propagating case and 30 for the forward propagating case. Is
        # there a better way to set the initial conditions?
        x0 = [30, 100, 0, 1]
        res = least_squares(self.residuals, x0, jac=self.jac)
        self.A, self.kspp, self.omega, self.phi = res.x

    def __call__(self, x, t):
        return self.plasmon(x, t, self.A, self.kspp, self.omega,
                            self.phi)

    def __repr__(self):
        info = []
        info.append('A = {}'.format(self.A))
        info.append('kspp = {}'.format(self.kspp))
        info.append('omega = {}'.format(self.omega))
        info.append('phi = {}'.format(self.phi))
        return '\n'.join(info)


# class FittedPlasmon():
#     def __init__(self, xdata, ydata):
#         self.xdata, self.ydata = xdata, ydata
#         self.fit()

#     def f(self, x, A, kxspp, phi):
#         return A*np.cos(kxspp*x - phi)

#     def jac(self, x, A, kxspp, phi):
#         out = np.empty((x.size, 3))
#         sinfac = np.sin(kxspp*x - phi)
#         out[:,0] = np.cos(kxspp*x - phi)
#         out[:,1] = -A*x*sinfac
#         out[:,2] = A*sinfac
#         return out

#     def fit(self):
#         # To get good results it seems necessary to give a better
#         # initial guess for `kxspp`.
#         popt, _ = curve_fit(self.f, self.xdata, self.ydata, jac=self.jac,
#                             p0=[1.0, 100.0, 1.0])
#         self.A, self.kxspp, self.phi = popt

#     def __call__(self, x):
#         return self.f(x, self.A, self.kxspp, self.phi)

#     def __repr__(self):
#         info = []
#         info.append('A = {}'.format(self.A))
#         info.append('kxspp = {}'.format(self.kxspp))
#         info.append('phi = {}'.format(self.phi))
#         return '\n'.join(info)


class AnimatedPlasmon():
    def __init__(self, firststep, laststep, interval):
        self.firststep, self.laststep = firststep, laststep
        self.interval = interval

        self.x = load_buf('vtk/geometry.dat')
        self.xfine = np.linspace(-2, 2, 10000)

        self.fig, self.ax = plt.subplots()
        self.line, = self.ax.plot([], [], 'b', animated=True)

    def init_func(self):
        self.ax.set_xlim(-2.0, 2.0)
        self.ax.set_ylim(-20.0, 20.0)
        return self.line,

    def data_gen(self):
        for i in range(self.firststep, self.laststep, self.interval):
            filename = 'vtk/plasmon{:07d}.dat'.format(i)
            ex = load_buf(filename)
            exfine = interpolate_field(self.xfine, self.x, ex)
            yield self.xfine, exfine

    def run(self, data):
        xfine, exfine = data
        self.line.set_data(xfine, exfine)
        return self.line,

    def show(self):
        ani = FuncAnimation(self.fig, self.run, self.data_gen,
                            init_func=self.init_func,
                            repeat=False, blit=True)
        plt.show()


def main():
    # AnimatedPlasmon(107000, 108500, 100).show()

    firststep = 107000
    laststep = 108500
    interval = 100
    # Use this for the backwards propagating plasmon
    # xmin = -0.6
    # xmax = -0.3
    # Use this for the forwards propagating plasmon
    xmin = 0.1
    xmax = 0.4

    dt = 3.228e-4
    ts = []
    xs = []
    exs = []

    x = load_buf('vtk/geometry.dat')
    for i in range(firststep, laststep, interval):
        filename = 'vtk/plasmon{:07d}.dat'.format(i)
        ex = load_buf(filename)
        xfine = np.linspace(xmin, xmax, 5000)
        exfine = interpolate_field(xfine, x, ex)
        exs.append(exfine)
        xs.append(xfine)
        ts.append([i*dt])
    ts, xs = np.broadcast_arrays(ts, xs)
    exs = np.array(exs)

    fittedPlasmon = FittedPlasmon(xs, ts, exs)
    print(fittedPlasmon)
    plt.plot(xs[-1], exs[-1], label='Numeric solution')
    plt.plot(xs[-1], fittedPlasmon(xs[-1], ts[-1]), label='Fitted curve')
    plt.legend()
    plt.show()


if __name__ == '__main__':
    main()
