import struct

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit


def load_buf(filename):
    with open(filename, mode='rb') as f:
        content = f.read()
        data = [x for x in struct.iter_unpack('d', content)]
    return np.array(data)


def get_timeseries(index, firststep, laststep, step):
    series = []
    for i in range(firststep, laststep, step):
        filename = 'vtk/hx{:07d}.dat'.format(i)
        hx = load_buf(filename)
        series.append(hx[index])
    return np.squeeze(np.asarray(series))


class FittedSine():
    def __init__(self, tdata, hdata, kz, z, omega):
        self.tdata, self.hdata = tdata, hdata
        self.kz, self.z, self.omega = kz, z, omega
        self.fit()

    def f(self, t, A, phi):
        return A*np.sin((-self.kz*self.z) - self.omega*t - phi)

    def jac(self, t, A, phi):
        out = np.empty((t.size, 2))
        arg = -self.kz*self.z - self.omega*t - phi
        out[:,0] = np.sin(arg)
        out[:,1] = -A*np.cos(arg)
        return out

    def fit(self):
        bounds = ([0, 0], [np.inf, 2*np.pi])
        popt, _ = curve_fit(self.f, self.tdata, self.hdata,
                            bounds=bounds)
        self.A, self.phi = popt

    def __call__(self, t):
        return self.f(t, self.A, self.phi)

    def __repr__(self):
        info = []
        info.append('A = {}'.format(self.A))
        info.append('phi = {}'.format(self.phi))
        return '\n'.join(info)


def main():
    firststep = 12000
    laststep = 16075
    step = 25

    dt = 6.21535e-3
    z = -7.1050072
    omega = .9926
    eps = 1.0
    mu = 1.0

    kz = np.sqrt(eps*mu)*omega

    x = load_buf('vtk/xcoordinates.dat')
    y = load_buf('vtk/ycoordinates.dat')

    phi = []
    start = x.size//2
    end = x.size//2+1
    for index in range(start, end):
        hx = get_timeseries(index, firststep, laststep, step)
        times = dt*np.arange(firststep, laststep, step)
        hxinc = np.sin(-kz*z - omega*times)
        fit = FittedSine(times, hx, kz, z, omega)
        print("On step {}/{}, phi = {}".format(index - start + 1,
                                               end - start, fit.phi))
        phi.append(fit.phi)
    phi = np.asarray(phi)
#    print (np.std(phi))
#    phi = np.mean(phi)
    hist, bins = np.histogram(phi)
    width = 0.7*(bins[1] - bins[0])
    center = (bins[:-1] + bins[1:])/2
#    plt.bar(center, hist, align='center', width=width)
#    plt.show()

    print(fit.A)
    plt.plot(times, hxinc, 'b', label='incident')
    plt.plot(times, hx, 'r', label='scattered')
    plt.plot(times, fit(times), 'g', label='fit')
    plt.legend()
    locs, labels = plt.xticks()
    newlocs = np.linspace(min(locs), max(locs), 14)
    plt.xticks(newlocs)
    plt.grid()
    plt.show()
    return fit.phi


if __name__ == '__main__':
    main()
