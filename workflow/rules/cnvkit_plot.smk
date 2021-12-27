# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Jonas Almlöf"
__copyright__ = "Copyright 2021, Jonas Almlöf"
__email__ = "jonas.almlof@scilifelab.uu.se"
__license__ = "GPL-3"


rule cnvkit_plot:
    input:
        segments="cnv_sv/cnvkit_call/{sample}/{sample}_{type}.cns",
        segment_regions="cnv_sv/cnvkit_call/{sample}/{sample}_{type}.cnr",
        vcf="cnv_sv/germline_vcf/{sample}_{type}.germline.vcf",
    output:
        plot=temp("cnv_sv/cnvkit_plot/{sample}_{type}.png"),
    params:
        extra=config.get("cnvkit_plot", {}).get("extra", ""),
    log:
        "cnv_sv/cnvkit_plot/{sample}_{type}.log",
    benchmark:
        repeat(
            "cnv_sv/cnvkit_plot/{sample}_{type}.benchmark.tsv",
            config.get("cnvkit_plot", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("cnvkit_plot", {}).get("threads", config["default_resources"]["threads"])
    resources:
        threads=config.get("cnvkit_plot", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("cnvkit_plot", {}).get("time", config["default_resources"]["time"]),
        mem_mb=config.get("cnvkit_plot", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("cnvkit_plot", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("cnvkit_plot", {}).get("partition", config["default_resources"]["partition"]),
    container:
        config.get("cnvkit_plot", {}).get("container", config["default_container"])
    conda:
        "../envs/cnvkit_plot.yaml"
    message:
        "{rule}: Plot cnvs into cnv_sv/cnvkit_plot/{wildcards.sample}_{wildcards.type}.png"
    shell:
        "(cnvkit.py scatter {input.segment_regions} -s {input.segments} -v {input.vcf} -o {output.plot} {params.extra}) &> {log}"
