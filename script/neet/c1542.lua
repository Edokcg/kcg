--元素英雄 神·新宇侠·未来(neet)
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,89943723,1,s.matfilter,4)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit,nil,nil,nil,false)
	--Apply effects if Fusion Summoned with specific materials
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1a:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e1a:SetOperation(s.operation)
	c:RegisterEffect(e1a)
	--Material Check
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_SINGLE)
	e1b:SetCode(EFFECT_MATERIAL_CHECK)
	e1b:SetValue(s.valcheck)
	e1b:SetLabelObject(e1a)
	c:RegisterEffect(e1b)   
end
s.listed_series={0x8,0x9,0x1f}
s.listed_names={89943723}
function s.matfilter(c,fc,sumtype,tp)
	return c:IsSetCard(0x8,fc,sumtype,tp) or c:IsSetCard(0x9,fc,sumtype,tp) or c:IsSetCard(0x1f,fc,sumtype,tp)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local neog=g:Filter(Card.IsCode,nil,89943723)
	local mg=g:Sub(neog)
	if #neog>0 then
		local neo=neog:GetFirst()
		neog:RemoveCard(neo)
		mg:Merge(neog)
	end
	local flag=0
	if mg:IsExists(Card.IsSetCard,1,nil,0x9) then flag=flag+1 end
	if mg:IsExists(Card.IsSetCard,1,nil,0x1f) then flag=flag+2 end
	if mg:IsExists(Card.IsSetCard,1,nil,0x8) then flag=flag+4 end
	e:GetLabelObject():SetLabel(flag)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local flag=e:GetLabel()
	local c=e:GetHandler()
	if (flag&1)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		e1:SetTarget(s.tgtg)
		e1:SetOperation(s.tgop)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	end
	if (flag&2)>0 then
		--to hand
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,4))
		e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetTarget(s.thtg)
		e2:SetOperation(s.thop)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	end
	if (flag&4)>0 then
		--cannot be target
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(aux.tgoval)
		e3:SetReset(RESET_EVENT|RESETS_STANDARD)
		c:RegisterEffect(e3)
		--indestructable
		local e4=e3:Clone()
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e4:SetValue(1)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
end
function s.tgfilter(c)
	return c:IsMonster() and (c:IsSetCard(0x9) or c:IsSetCard(0x1f) or c:IsSetCard(0x8)) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetBaseAttack())
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end
function s.thfilter(c)
	return c:IsMonster() and (c:IsSetCard(0x9) or c:IsSetCard(0x1f) or c:IsSetCard(0x8)) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end