﻿using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Backend.Models.DTO.Review;
using System.Security.Claims;
using Backend.Models.API;
using Backend.Services;

namespace Backend.Controllers;

[Route("[controller]")]
[ApiController]
public class ReviewsController : ControllerBase
{
    private readonly IReviewService _reviewService;

    public ReviewsController(IReviewService reviewService)
    {
        _reviewService = reviewService;
    }

    [HttpPost]
    [Authorize(Policy = "VerifiedUser")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> CreateReview([FromBody] CreateReviewRequest reviewReq)
    {
        var claims = HttpContext.User.Claims;
        var UserId = int.Parse(claims.First(c => c.Type == ClaimTypes.Name).Value);
        await _reviewService.CreateReview(UserId, reviewReq);
        return Ok(new GenericResponse("Review created successfully"));
    }

    [HttpDelete("{id}")]
    [Authorize(Policy = "VerifiedUser")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> DeleteReview([FromRoute] int id)
    {
        var claims = HttpContext.User.Claims.ToArray();
        var claimedId = int.Parse(claims.First(c => c.Type == ClaimTypes.Name).Value);
        await _reviewService.DeleteReview(claimedId, id);
        return Ok(new GenericResponse("Review deleted successfully"));
    }

    [HttpPut("{id}")]
    [Authorize(Policy = "VerifiedUser")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> UpdateReview([FromRoute] int id, [FromBody] UpdateReviewRequest req)
    {
        var claims = HttpContext.User.Claims.ToArray();
        var claimedId = int.Parse(claims.First(c => c.Type == ClaimTypes.Name).Value);
        await _reviewService.UpdateReview(claimedId, id, req);
        return Ok(new GenericResponse("Review updated successfully"));
    }
}
