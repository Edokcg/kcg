--奥利哈刚 暗黑的赠礼(ZCG)
function c77239251.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239251.target)
    e1:SetOperation(c77239251.activate)
    c:RegisterEffect(e1)
end

function c77239251.dafilter(c)
    return c:IsFaceup() and (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) 
	or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174)))
end
--[[function c77239251.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local gc=Duel.GetMatchingGroupCount(c77239251.dafilter,tp,LOCATION_MZONE,0,nil)
        e:SetLabel(gc)
        return gc>0 and Duel.IsPlayerCanDraw(tp,gc)
    end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(e:GetLabel())
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,gc)
end
function c77239251.activate(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local g=Duel.GetMatchingGroupCount(c77239251.dafilter,tp,LOCATION_MZONE,0,nil)
    Duel.Draw(p,g,REASON_EFFECT)
end]]

function c77239251.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local gc=Duel.GetMatchingGroupCount(c77239251.dafilter,tp,LOCATION_MZONE,0,nil)
		e:SetLabel(gc)
		return gc>0 and Duel.IsPlayerCanDraw(tp,gc)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c77239251.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroupCount(c77239251.dafilter,tp,LOCATION_MZONE,0,nil)
	Duel.Draw(p,g,REASON_EFFECT)
end