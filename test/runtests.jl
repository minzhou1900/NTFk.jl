import NTFk
import Base.Test

@Base.Test.testset "NTFk ploting" begin
	r = reshape(repeat(collect(1/100:1/100:1), inner=100), (100,100))
	d = NTFk.plotmatrix(r; colormap=NTFk.colormap_hsv2);
	display(d); println()
	d = NTFk.plotmatrix(r; colormap=NTFk.colormap_hsv);
	display(d); println()
	@Base.Test.test isapprox(1, 1, atol=1e-6)
end

@Base.Test.testset "NTFk analysis" begin
	srand(1)
	csize = (2, 3, 4)
	tsize = (5, 10, 15)
	tucker_orig = NTFk.rand_tucker(csize, tsize, factors_nonneg=true, core_nonneg=true)
	T_orig = TensorDecompositions.compose(tucker_orig)
	tucker_spnn, ecsize, ibest = NTFk.analysis(T_orig, [csize], 1; eigmethod=[false,false,false], progressbar=false, tol=1e-12, max_iter=100, lambda=0.);
	T_spnn = TensorDecompositions.compose(tucker_spnn[1])
	@Base.Test.test csize == ecsize
	@Base.Test.test isapprox(vecnorm(T_orig .- T_spnn), 7.191, atol=1e-3)
end

@Base.Test.test 1 == 1