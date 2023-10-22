filter Test-IsNotNullOrEmpty {
    <#
        .SYNOPSIS
        Test if an object is not null or empty

        .DESCRIPTION
        Test if an object is not null or empty

        .EXAMPLE
        '' | Test-IsNotNullOrEmpty

        False
    #>
    [Alias('IsNotNullOrEmpty')]
    [Cmdletbinding()]
    [OutputType([bool])]
    param(
        # Object to test
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [object] $Object
    )
    return -not ($Object | IsNullOrEmpty)

}
