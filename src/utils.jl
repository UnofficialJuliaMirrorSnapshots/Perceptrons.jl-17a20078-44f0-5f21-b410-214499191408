

## Auxiliary functions
export acc

@inline acc(yt,yp) = count(x->x==true, yt .== yp)/length(yt)

# used in linear and voted perceptron
@inline sinal(x) = ( x>=0 ? 1.0 : 0.0 )
# used in kernel perceptron
@inline sign(val) = ( val >=0 ? 1.0 : -1.0 )


## checks PLS input data and params
function check_data(X::Matrix{T},Y::Union{Vector{T},Matrix{T}}) where T<:AbstractFloat
    !isempty(X) ||
        throw(DimensionMismatch("Empty input data (X)."))
    !isempty(Y) ||
        throw(DimensionMismatch("Empty target data (Y)."))
    size(X, 1) == size(Y, 1) ||
        throw(DimensionMismatch("Incompatible number of rows of input data (X) and target data (Y)."))
end

function check_data(X::Matrix{T},nfeatures::Int) where T<:AbstractFloat
    !isempty(X) ||
        throw(DimensionMismatch("Empty input data (X)."))
    size(X, 2) == nfeatures ||
        throw(DimensionMismatch("Incompatible number of columns of input data (X) and original training X columns."))
end


function check_params(kernel::AbstractString,mode::AbstractString)
    kernel in ["rbf","linear"] || error("kernel must be 'linear' or 'rbf'")
    mode   in ["kernel","linear","voted","averaged"] || error("mode must be 'linear' or 'kernel' or 'voted' or 'averaged'")
end

## checks constant columns
check_constant_cols(X::Matrix{T}) where {T<:AbstractFloat} = size(X,1)>1 && !any(all(X .== X[1,:]',dims=1)) || error("You must remove constant columns of input data (X) before train")
check_constant_cols(Y::Vector{T}) where {T<:AbstractFloat} = length(Y)>1 && length(unique(Y)) > 1 || error("Your target values are constant. All values are equal to $(Y[1])")

## Preprocessing data using z-score statistics. this is due to the fact that if X and Y are z-scored, than X'Y returns for W vector a pearson correlation for each element! :)
centralize_data(D::AbstractArray{T}, m::AbstractArray{T}, s::AbstractArray{T}) where {T<:AbstractFloat}  = (D .-m)./s
centralize_data(D::Vector{T}, m::T, s::T)  where {T<:AbstractFloat} = (D -m)/s

decentralize_data(D::AbstractArray{T}, m::AbstractArray{T}, s::AbstractArray{T}) where {T<:AbstractFloat} = D .*s .+m
decentralize_data(D::Vector{T}, m::T, s::T)  where {T<:AbstractFloat}               = D *s +m

check_linear_binary_labels(Y::Vector{T}) where {T<:Number} = length(setdiff(Y,[0.,1.]))==0 || error("Your target values must be 1 and 0 only. You have $(unique(Y)) distinct labels")
