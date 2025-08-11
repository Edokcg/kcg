--ＤＤＤ シンクロ
--D/D/D Synchro
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_series={0xaf, 0x10af}

function s.filter(c,e,tp,rel)
	if not c:IsType(TYPE_SYNCHRO) then return false end
	if not c:IsSetCard(0x10af) then
		return c:IsSynchroSummonable(nil)
	else
		local mg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c)
		if c:IsSynchroSummonable(nil,mg) then return true end
		local mc=e:GetHandler()
		if not (e:IsHasType(EFFECT_TYPE_ACTIVATE) and (not rel or mc:IsRelateToEffect(e))) then return false end
		local e1=Effect.CreateEffect(mc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_MONSTER+TYPE_TUNER)
		e1:SetReset(RESET_CHAIN)
		mc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SYNCHRO_LEVEL)
		e2:SetValue(2)
		mc:RegisterEffect(e2)
		mg:AddCard(mc)
		local res=mg:IsExists(s.ddfilter,1,nil,c,mg,mc)
		e1:Reset()
		e2:Reset()
		return res
	end
end
function s.ddfilter(c,sc,mg,mc)
	return c:IsSetCard(0x10af) and sc:IsSynchroSummonable(Group.FromCards(c,mc),mg)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_EXTRA,0,nil,e,tp,true)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if not tc:IsSetCard(0x10af) then
			Duel.SynchroSummon(tp,tc,nil)
		else
			local mg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,tc)
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetValue(TYPE_MONSTER+TYPE_TUNER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SYNCHRO_LEVEL)
			e2:SetValue(2)
			c:RegisterEffect(e2)
			if e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsRelateToEffect(e) and (not tc:IsSynchroSummonable(nil,mg) or mg:IsExists(s.ddfilter,1,nil,tc,mg+c,c) and Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
				c:CancelToGrave()
				mg:AddCard(c)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local smat=mg:FilterSelect(tp,s.ddfilter,1,1,nil,tc,mg,c)
				Duel.SynchroSummon(tp,tc,smat+c,mg)
			else
				Duel.SynchroSummon(tp,tc,nil,mg)
			end
		end
	end
end

function s.thfilter(c)
	return c:IsSetCard(0xaf) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end