! function () {
	"use strict";
	var r = .5 * (Math.sqrt(3) - 1),
		e = (3 - Math.sqrt(3)) / 6,
		t = 1 / 6,
		a = (Math.sqrt(5) - 1) / 4,
		o = (5 - Math.sqrt(5)) / 20;

	function i(r) {
		var e;
		e = "function" == typeof r ? r : r ? function () {
			var r = 0,
				e = 0,
				t = 0,
				a = 1,
				o = (i = 4022871197, function (r) {
					r = r.toString();
					for (var e = 0; e < r.length; e++) {
						var t = .02519603282416938 * (i += r.charCodeAt(e));
						t -= i = t >>> 0, i = (t *= i) >>> 0, i += 4294967296 * (t -= i)
					}
					return 2.3283064365386963e-10 * (i >>> 0)
				});
			var i;
			r = o(" "), e = o(" "), t = o(" ");
			for (var n = 0; n < arguments.length; n++)(r -= o(arguments[n])) < 0 && (r += 1), (e -= o(arguments[n])) < 0 && (e += 1), (t -= o(arguments[n])) < 0 && (t += 1);
			return o = null,
				function () {
					var o = 2091639 * r + 2.3283064365386963e-10 * a;
					return r = e, e = t, t = o - (a = 0 | o)
				}
		}(r) : Math.random, this.p = n(e), this.perm = new Uint8Array(512), this.permMod12 = new Uint8Array(512);
		for (var t = 0; t < 512; t++) this.perm[t] = this.p[255 & t], this.permMod12[t] = this.perm[t] % 12
	}

	function n(r) {
		var e, t = new Uint8Array(256);
		for (e = 0; e < 256; e++) t[e] = e;
		for (e = 0; e < 255; e++) {
			var a = e + ~~(r() * (256 - e)),
				o = t[e];
			t[e] = t[a], t[a] = o
		}
		return t
	}
	i.prototype = {
		grad3: new Float32Array([1, 1, 0, -1, 1, 0, 1, -1, 0, -1, -1, 0, 1, 0, 1, -1, 0, 1, 1, 0, -1, -1, 0, -1, 0, 1, 1, 0, -1, 1, 0, 1, -1, 0, -1, -1]),
		grad4: new Float32Array([0, 1, 1, 1, 0, 1, 1, -1, 0, 1, -1, 1, 0, 1, -1, -1, 0, -1, 1, 1, 0, -1, 1, -1, 0, -1, -1, 1, 0, -1, -1, -1, 1, 0, 1, 1, 1, 0, 1, -1, 1, 0, -1, 1, 1, 0, -1, -1, -1, 0, 1, 1, -1, 0, 1, -1, -1, 0, -1, 1, -1, 0, -1, -1, 1, 1, 0, 1, 1, 1, 0, -1, 1, -1, 0, 1, 1, -1, 0, -1, -1, 1, 0, 1, -1, 1, 0, -1, -1, -1, 0, 1, -1, -1, 0, -1, 1, 1, 1, 0, 1, 1, -1, 0, 1, -1, 1, 0, 1, -1, -1, 0, -1, 1, 1, 0, -1, 1, -1, 0, -1, -1, 1, 0, -1, -1, -1, 0]),
		noise2D: function (t, a) {
			var o, i, n = this.permMod12,
				f = this.perm,
				s = this.grad3,
				v = 0,
				h = 0,
				l = 0,
				u = (t + a) * r,
				d = Math.floor(t + u),
				p = Math.floor(a + u),
				M = (d + p) * e,
				m = t - (d - M),
				c = a - (p - M);
			m > c ? (o = 1, i = 0) : (o = 0, i = 1);
			var y = m - o + e,
				w = c - i + e,
				g = m - 1 + 2 * e,
				A = c - 1 + 2 * e,
				x = 255 & d,
				q = 255 & p,
				D = .5 - m * m - c * c;
			if (D >= 0) {
				var S = 3 * n[x + f[q]];
				v = (D *= D) * D * (s[S] * m + s[S + 1] * c)
			}
			var U = .5 - y * y - w * w;
			if (U >= 0) {
				var b = 3 * n[x + o + f[q + i]];
				h = (U *= U) * U * (s[b] * y + s[b + 1] * w)
			}
			var F = .5 - g * g - A * A;
			if (F >= 0) {
				var N = 3 * n[x + 1 + f[q + 1]];
				l = (F *= F) * F * (s[N] * g + s[N + 1] * A)
			}
			return 70 * (v + h + l)
		},
		noise3D: function (r, e, a) {
			var o, i, n, f, s, v, h, l, u, d, p = this.permMod12,
				M = this.perm,
				m = this.grad3,
				c = (r + e + a) * (1 / 3),
				y = Math.floor(r + c),
				w = Math.floor(e + c),
				g = Math.floor(a + c),
				A = (y + w + g) * t,
				x = r - (y - A),
				q = e - (w - A),
				D = a - (g - A);
			x >= q ? q >= D ? (s = 1, v = 0, h = 0, l = 1, u = 1, d = 0) : x >= D ? (s = 1, v = 0, h = 0, l = 1, u = 0, d = 1) : (s = 0, v = 0, h = 1, l = 1, u = 0, d = 1) : q < D ? (s = 0, v = 0, h = 1, l = 0, u = 1, d = 1) : x < D ? (s = 0, v = 1, h = 0, l = 0, u = 1, d = 1) : (s = 0, v = 1, h = 0, l = 1, u = 1, d = 0);
			var S = x - s + t,
				U = q - v + t,
				b = D - h + t,
				F = x - l + 2 * t,
				N = q - u + 2 * t,
				C = D - d + 2 * t,
				P = x - 1 + .5,
				T = q - 1 + .5,
				_ = D - 1 + .5,
				j = 255 & y,
				k = 255 & w,
				z = 255 & g,
				B = .6 - x * x - q * q - D * D;
			if (B < 0) o = 0;
			else {
				var E = 3 * p[j + M[k + M[z]]];
				o = (B *= B) * B * (m[E] * x + m[E + 1] * q + m[E + 2] * D)
			}
			var G = .6 - S * S - U * U - b * b;
			if (G < 0) i = 0;
			else {
				var H = 3 * p[j + s + M[k + v + M[z + h]]];
				i = (G *= G) * G * (m[H] * S + m[H + 1] * U + m[H + 2] * b)
			}
			var I = .6 - F * F - N * N - C * C;
			if (I < 0) n = 0;
			else {
				var J = 3 * p[j + l + M[k + u + M[z + d]]];
				n = (I *= I) * I * (m[J] * F + m[J + 1] * N + m[J + 2] * C)
			}
			var K = .6 - P * P - T * T - _ * _;
			if (K < 0) f = 0;
			else {
				var L = 3 * p[j + 1 + M[k + 1 + M[z + 1]]];
				f = (K *= K) * K * (m[L] * P + m[L + 1] * T + m[L + 2] * _)
			}
			return 32 * (o + i + n + f)
		},
		noise4D: function (r, e, t, i) {
			var n, f, s, v, h, l, u, d, p, M, m, c, y, w, g, A, x, q = this.perm,
				D = this.grad4,
				S = (r + e + t + i) * a,
				U = Math.floor(r + S),
				b = Math.floor(e + S),
				F = Math.floor(t + S),
				N = Math.floor(i + S),
				C = (U + b + F + N) * o,
				P = r - (U - C),
				T = e - (b - C),
				_ = t - (F - C),
				j = i - (N - C),
				k = 0,
				z = 0,
				B = 0,
				E = 0;
			P > T ? k++ : z++, P > _ ? k++ : B++, P > j ? k++ : E++, T > _ ? z++ : B++, T > j ? z++ : E++, _ > j ? B++ : E++;
			var G = P - (l = k >= 3 ? 1 : 0) + o,
				H = T - (u = z >= 3 ? 1 : 0) + o,
				I = _ - (d = B >= 3 ? 1 : 0) + o,
				J = j - (p = E >= 3 ? 1 : 0) + o,
				K = P - (M = k >= 2 ? 1 : 0) + 2 * o,
				L = T - (m = z >= 2 ? 1 : 0) + 2 * o,
				O = _ - (c = B >= 2 ? 1 : 0) + 2 * o,
				Q = j - (y = E >= 2 ? 1 : 0) + 2 * o,
				R = P - (w = k >= 1 ? 1 : 0) + 3 * o,
				V = T - (g = z >= 1 ? 1 : 0) + 3 * o,
				W = _ - (A = B >= 1 ? 1 : 0) + 3 * o,
				X = j - (x = E >= 1 ? 1 : 0) + 3 * o,
				Y = P - 1 + 4 * o,
				Z = T - 1 + 4 * o,
				$ = _ - 1 + 4 * o,
				rr = j - 1 + 4 * o,
				er = 255 & U,
				tr = 255 & b,
				ar = 255 & F,
				or = 255 & N,
				ir = .6 - P * P - T * T - _ * _ - j * j;
			if (ir < 0) n = 0;
			else {
				var nr = q[er + q[tr + q[ar + q[or]]]] % 32 * 4;
				n = (ir *= ir) * ir * (D[nr] * P + D[nr + 1] * T + D[nr + 2] * _ + D[nr + 3] * j)
			}
			var fr = .6 - G * G - H * H - I * I - J * J;
			if (fr < 0) f = 0;
			else {
				var sr = q[er + l + q[tr + u + q[ar + d + q[or + p]]]] % 32 * 4;
				f = (fr *= fr) * fr * (D[sr] * G + D[sr + 1] * H + D[sr + 2] * I + D[sr + 3] * J)
			}
			var vr = .6 - K * K - L * L - O * O - Q * Q;
			if (vr < 0) s = 0;
			else {
				var hr = q[er + M + q[tr + m + q[ar + c + q[or + y]]]] % 32 * 4;
				s = (vr *= vr) * vr * (D[hr] * K + D[hr + 1] * L + D[hr + 2] * O + D[hr + 3] * Q)
			}
			var lr = .6 - R * R - V * V - W * W - X * X;
			if (lr < 0) v = 0;
			else {
				var ur = q[er + w + q[tr + g + q[ar + A + q[or + x]]]] % 32 * 4;
				v = (lr *= lr) * lr * (D[ur] * R + D[ur + 1] * V + D[ur + 2] * W + D[ur + 3] * X)
			}
			var dr = .6 - Y * Y - Z * Z - $ * $ - rr * rr;
			if (dr < 0) h = 0;
			else {
				var pr = q[er + 1 + q[tr + 1 + q[ar + 1 + q[or + 1]]]] % 32 * 4;
				h = (dr *= dr) * dr * (D[pr] * Y + D[pr + 1] * Z + D[pr + 2] * $ + D[pr + 3] * rr)
			}
			return 27 * (n + f + s + v + h)
		}
	}, i._buildPermutationTable = n, "undefined" != typeof define && define.amd && define(function () {
		return i
	}), "undefined" != typeof exports ? exports.SimplexNoise = i : "undefined" != typeof window && (window.SimplexNoise = i), "undefined" != typeof module && (module.exports = i)
}();

"use strict";
var _slicedToArray = function () {
	function sliceIterator(arr, i) {
		var _arr = [];
		var _n = true;
		var _d = false;
		var _e = undefined;
		try {
			for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) {
				_arr.push(_s.value);
				if (i && _arr.length === i) break;
			}
		} catch (err) {
			_d = true;
			_e = err;
		} finally {
			try {
				if (!_n && _i["return"]) _i["return"]();
			} finally {
				if (_d) throw _e;
			}
		}
		return _arr;
	}
	return function (arr, i) {
		if (Array.isArray(arr)) {
			return arr;
		} else if (Symbol.iterator in Object(arr)) {
			return sliceIterator(arr, i);
		} else {
			throw new TypeError("Invalid attempt to destructure non-iterable instance");
		}
	};
}();

function _toConsumableArray(arr) {
	if (Array.isArray(arr)) {
		for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) {
			arr2[i] = arr[i];
		}
		return arr2;
	} else {
		return Array.from(arr);
	}
}
var

	PI = Math.PI,
	cos = Math.cos,
	sin = Math.sin,
	abs = Math.abs,
	random = Math.random,
	atan2 = Math.atan2;
var TAU = 2 * PI;
var rand = function rand(n) {
	return n * random();
};
var randIn = function randIn(min, max) {
	return rand(max - min) + min;
};
var fadeInOut = function fadeInOut(t, m) {
	var hm = 0.5 * m;
	return abs((t + hm) % m - hm) / hm;
};
var angle = function angle(x1, y1, x2, y2) {
	return atan2(y2 - y1, x2 - x1);
};
var lerp = function lerp(n1, n2, speed) {
	return (1 - speed) * n1 + speed * n2;
};

var particleCount = 300;

var canvas = void 0;
var ctx = void 0;
var hover = void 0;
var mouse = void 0;
var origin = void 0;
var particles = void 0;

function getParticle() {
	var particle = {
		get alpha() {
			return fadeInOut(this.life, this.ttl);
		},
		init: function init() {
			var _window =
				window,
				innerWidth = _window.innerWidth,
				innerHeight = _window.innerHeight;
			var direction = rand(TAU);
			var speed = randIn(20, 40);

			this.life = 0;
			this.ttl = randIn(100, 300);
			this.size = randIn(2, 8);
			this.hue = randIn(80, 150);
			this.size = randIn(2, 8);
			this.hue = randIn(80, 150);
			this.position = [
				origin[0] + rand(200) * cos(direction),
				origin[1] + rand(200) * sin(direction)
			];

			this.velocity = [
				cos(direction) * speed,
				sin(direction) * speed
			];

		},
		checkBounds: function checkBounds() {
			var _position = _slicedToArray(
				this.position, 2),
				x = _position[0],
				y = _position[1];

			return (
				x > canvas.a.width + this.size ||
				x < -this.size ||
				y > canvas.a.height + this.size ||
				y < -this.size);

		},
		update: function update() {
			var _position2 = _slicedToArray(
				this.position, 2),
				x = _position2[0],
				y = _position2[1];
			var _velocity = _slicedToArray(
				this.velocity, 2),
				vX = _velocity[0],
				vY = _velocity[1];
			var mDirection = angle.apply(undefined, _toConsumableArray(mouse).concat(_toConsumableArray(this.position)));
			this.position[0] = lerp(x, x + vX, 0.05);
			this.position[1] = lerp(y, y + vY, 0.05);
			this.velocity[0] = lerp(vX, hover ? cos(mDirection) * 30 : 0, hover ? 0.1 : 0.01);
			this.velocity[1] = lerp(vY, hover ? sin(mDirection) * 30 : 0, hover ? 0.1 : 0.01);
			(this.checkBounds() || this.life++ > this.ttl) && this.init();

			return this;
		},
		draw: function draw() {
			var _ctx$a;
			ctx.a.save();
			ctx.a.beginPath();
			ctx.a.fillStyle = "hsla(" + this.hue + ",50%,50%," + this.alpha + ")";
			(_ctx$a = ctx.a).arc.apply(_ctx$a, _toConsumableArray(this.position).concat([this.size, 0, TAU]));
			ctx.a.fill();
			ctx.a.closePath();
			ctx.a.restore();

			return this;
		}
	};


	particle.init();

	return particle;
}

function initParticles() {
	particles = [];

	for (var i = 0; i < particleCount; i++) {
		particles.push(getParticle());
	}
}

function setup() {
	canvas = {
		a: document.createElement("canvas"),
		b: document.createElement("canvas")
	};

	canvas.b.style = "\n\t\tposition: absolute;\n\t\ttop: 0;\n\t\tleft: 0;\n\t\twidth: 100%;\n\t\theight: 100%;\n\t";

	document.body.appendChild(canvas.b);

	ctx = {
		a: canvas.a.getContext("2d"),
		b: canvas.b.getContext("2d")
	};


	mouse = [0, 0];
	origin = [];

	resize();
	initParticles();
	draw();
}

function resize() {
	var _window2 =
		window,
		innerWidth = _window2.innerWidth,
		innerHeight = _window2.innerHeight;

	canvas.a.width = canvas.b.width = innerWidth;
	canvas.a.height = canvas.b.height = innerHeight;

	origin[0] = 0.5 * innerWidth;
	origin[1] = 0.5 * innerHeight;
}

function mouseHandler(event) {
	var
		type = event.type,
		clientX = event.clientX,
		clientY = event.clientY;

	hover = type === 'mousemove';

	mouse[0] = clientX;
	mouse[1] = clientY;
}

function draw() {
	ctx.a.clearRect(0, 0, canvas.a.width, canvas.a.height);
	ctx.b.fillStyle = 'rgba(20,20,20,0.8)';
	ctx.b.fillRect(0, 0, canvas.a.width, canvas.a.height);

	for (var _i = 0; _i < particles.length; _i++) {
		particles[_i].draw().update();
	}

	var i = void 0,
		amt = void 0;

	for (i = 20; i >= 1; i--) {
		var _ctx$b;
		amt = i * 0.05;
		ctx.b.save();
		ctx.b.filter = "blur(" + amt * 5 + "px)";
		ctx.b.globalAlpha = 1 - amt;
		ctx.b.setTransform(1 - amt, 0, 0, 1 - amt, origin[0] * amt, origin[1] * amt);
		(_ctx$b = ctx.b).translate.apply(_ctx$b, _toConsumableArray(origin));
		ctx.b.rotate(amt * 8);
		ctx.b.translate(-origin[0], -origin[1]);
		ctx.b.drawImage(canvas.a, 0, 0, canvas.b.width, canvas.b.height);
		ctx.b.restore();
	}

	ctx.b.save();
	ctx.b.filter = "blur(8px) brightness(200%)";
	ctx.b.drawImage(canvas.a, 0, 0);
	ctx.b.restore();

	ctx.b.save();
	ctx.b.globalCompositeOperation = "lighter";
	ctx.b.drawImage(canvas.a, 0, 0);
	ctx.b.restore();

	window.requestAnimationFrame(draw);
}

window.addEventListener("load", setup);
window.addEventListener("mousemove", mouseHandler);
window.addEventListener("mouseout", mouseHandler);
window.addEventListener("resize", resize);