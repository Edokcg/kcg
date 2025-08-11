--直播☆双子星 姬丝基勒·璃拉·传说(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x156),2,2)  
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,{id,0})
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1,false,EFFECT_MARKER_DETACH_XMAT)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,{id,0})
	e3:SetCost(Cost.SelfBanish)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
s.listed_series={SET_KI_SIKIL,SET_LIL_LA}
function s.kisikil(c)
	return c:IsSetCard(0x153) and not c:IsSetCard(0x154)
end
function s.lilla(c)
	return not c:IsSetCard(0x153) and c:IsSetCard(0x154)
end
function s.filter(c)
	return c:IsSetCard(0x153) and c:IsSetCard(0x154)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local g1=g:Filter(s.kisikil,nil) 
	local g2=g:Filter(s.lilla,nil)
	local g3=g:Filter(s.filter,nil)
	local b1=#g1>0 and Duel.IsPlayerCanDraw(tp,1)
	local b2=#g2>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
	local b3=#g3>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
	local op=0
	if chk==0 then return (b1 or b2 or b3) and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local og=Group.CreateGroup()
	if b1 then og:Merge(g1) end
	if b2 then og:Merge(g2) end
	if b3 then og:Merge(g3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local oc=og:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoGrave(oc,REASON_COST)
	local op=0
	if oc:IsSetCard(0x153) then op=op+1 end
	if oc:IsSetCard(0x154) then op=op+2 end
	e:SetLabel(op)
end
function s.thfilter(c)
	return c:IsMonster() and (c:IsSetCard(0x153) or c:IsSetCard(0x154)) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local op=e:GetLabel()
	local cate=e:GetCategory()
	if (op&1)>0 then 
		cate=cate|CATEGORY_DRAW
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
	end
	if (op&2)>0 then 
		cate=cate|CATEGORY_DESTROY 
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if (op&1)>0 and (op&2)>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT) 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #dg>0 then
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	elseif (op&1)>0 then 
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif (op&2)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #dg>0 then
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function s.spfilter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x153) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(s.spfilter3,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function s.spfilter3(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x154) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>1 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
			and Duel.IsExistingTarget(s.spfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,s.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,s.spfilter3,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetTargetCards(e)
	if #g==0 or (#g>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)) then return end
	if #g<=ft then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_RULE)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(_e,_c) return not _c:IsType(RACE_FIEND) and _c:IsLocation(LOCATION_EXTRA) end)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end