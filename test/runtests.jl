import NTFk
import Test
import Random

# @Test.testset "NTFk ploting" begin
# 	r = reshape(repeat(collect(1/100:1/100:1), inner=100), (100,100))
# 	d = NTFk.plotmatrix(r; colormap=NTFk.colormap_hsv2);
# 	display(d); println()
# 	d = NTFk.plotmatrix(r; colormap=NTFk.colormap_hsv);
# 	display(d); println()
# 	@Test.test isapprox(1, 1, atol=1e-6)
# end

@Test.testset "NTFk TensorDecompositions Tucker analysis" begin
	Random.seed!(1)
	csize = (2, 3, 4)
	tsize = (5, 10, 15)
	tucker_orig = NTFk.rand_tucker(csize, tsize, factors_nonneg=true, core_nonneg=true)
	T_orig = TensorDecompositions.compose(tucker_orig)
	tucker_est, csize_est, ibest = NTFk.analysis(T_orig, [csize], 1; seed=1, eigmethod=[false,false,false], progressbar=false, tol=1e-4, maxiter=100, lambda=0.)
	T_est = TensorDecompositions.compose(tucker_est[ibest])
	@Test.test csize == csize_est
	@show norm(T_orig .- T_est)
	@Test.test isapprox(norm(T_orig .- T_est), 1.0104725439065432, atol=1e-3)
end

@Test.testset "NTFk TensorDecompositions CP analysis" begin
	Random.seed!(1)
	csize = (2, 3, 4)
	tsize = (5, 10, 15)
	tucker_orig = NTFk.rand_tucker(csize, tsize, factors_nonneg=true, core_nonneg=true)
	T_orig = TensorDecompositions.compose(tucker_orig)
	cp_est, csize, ibest = NTFk.analysis(T_orig, [maximum(csize)], 1; seed=1, eigmethod=[false,false,false], progressbar=false, tol=1e-12, maxiter=100, lambda=0.)
	T_est = TensorDecompositions.compose(cp_est[ibest])
	@show norm(T_orig .- T_est)
	@Test.test isapprox(norm(T_orig .- T_est), 0.047453937969484744, atol=1e-3)
end

@Test.testset "NTFk Tensorly Tucker analysis" begin
	Random.seed!(1)
	csize = (2, 3, 4)
	tsize = (5, 10, 15)
	tucker_orig = NTFk.rand_tucker(csize, tsize, factors_nonneg=true, core_nonneg=true)
	T_orig = TensorDecompositions.compose(tucker_orig)
	for backend = ["tensorflow", "pytorch", "mxnet", "numpy"]
		tucker_est, csize_est, ibest = NTFk.analysis(T_orig, [csize], 1; seed=1, method="tensorly_", eigmethod=[false,false,false], progressbar=false, tol=1e-12, maxiter=100, backend=backend, verbose=true)
		T_est = TensorDecompositions.compose(tucker_est[ibest])
		@Test.test csize == csize_est
		@show norm(T_orig .- T_est)
		@Test.test isapprox(norm(T_orig .- T_est), 0.913, atol=1e-3)
	end
end

@Test.test 1 == 1