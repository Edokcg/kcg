--トゥーン・フリップ
local s,id=GetID()
function s.initial_effect(c)
	--Reveal 3 toon monsters from deck, special summon 1 of them
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE)
	c:RegisterEffect(e1)
end
s.listed_names={15259703}
        
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,15259703),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.spfilter(c,e,tp)
	return c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsPublic()
end
function s.spfilter2(c,e,tp)
	return c:IsMonster() and c:IsType(TYPE_TOON) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsPublic()
end
function s.filter2(c)
	return c:IsMonster() and not c:IsType(TYPE_TOON) and not c:IsSetCard(0x62)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rvg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (rvg:GetClassCount(Card.GetCode)>=3 or rvg:GetClassCount(Card.GetRealCode)>=3)
        and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rvg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
    if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (rvg:GetClassCount(Card.GetCode)>=3 or rvg:GetClassCount(Card.GetRealCode)>=3) 
    and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local ag=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,3,3,nil)
    if #ag~=3 then return end
	aux.cartoonize(e,tp,ag,0,0)
    Duel.ConfirmCards(1-tp,ag)
	local rvg2=Duel.GetMatchingGroup(s.spfilter2,tp,LOCATION_DECK,0,nil,e,tp)
    if #rvg2<3 then return end
	local rg=aux.SelectUnselectGroup(rvg2,e,tp,3,3,aux.dpcheck(Card.GetOriginalCode),1,tp,HINTMSG_CONFIRM)
	Duel.ConfirmCards(1-tp,rg)
	local tg=rg:RandomSelect(1-tp,1)
	local tc=tg:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		Duel.SendtoHand(rg,tp,0)
	end
end

function s.spfilterr(c)
	return c:IsMonster() and c:IsType(TYPE_TOON) and c:HasLevel() and c:IsLevelAbove(1) and c:IsReleasable()
end
function s.rescon(sg,e,tp,mg)
	if #sg>1 then
		return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:GetSum(Card.GetLevel)>=e:GetOwner():GetOriginalLevel() and not sg:IsExists(Card.IsLevelAbove,1,nil,8)
	else
		return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:GetSum(Card.GetLevel)>=e:GetOwner():GetOriginalLevel()
	end
end
function s.spconr(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(s.spfilterr,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler())
	return aux.SelectUnselectGroup(rg,e,tp,1,99,s.rescon,0)
end
function s.breakcon(sg,e,tp,mg)
	return sg:GetSum(Card.GetLevel)>=8
end
function s.sptgr(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(s.spfilterr,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler())
	local mg=aux.SelectUnselectGroup(rg,e,tp,1,99,s.rescon,1,tp,HINTMSG_RELEASE,s.breakcon,s.breakcon,true)
	if #mg>0 then
		mg:KeepAlive()
		e:SetLabelObject(mg)
		return true
	end
	return false
end
function s.spopr(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

function s.spcon0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,15259703),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.sptg0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spcon1(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),aux.TRUE,1,false,1,true,c,c:GetControler(),nil,false,nil)
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,15259703),c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,aux.TRUE,1,1,false,true,true,c,nil,nil,false,nil)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.spcon2(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),aux.TRUE,2,false,2,true,c,c:GetControler(),nil,false,nil)
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,15259703),c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,aux.TRUE,2,2,false,true,true,c,nil,nil,false,nil)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.spopn(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

function s.indes(e,c)
	return not c or not c:IsType(TYPE_TOON)
end

function s.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function s.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function s.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(s.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end

function s.sfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousCodeOnField()==15259703 and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.sdescon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.sfilter,1,nil)
end
function s.sdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end