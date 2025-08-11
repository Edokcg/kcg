--オレイカルコス・ミラー
--Orichalcos Mirror
local s,id=GetID()
function s.initial_effect(c)
	Ritual.AddProcGreater({handler=c,filter=s.ritualfil,lvtype=RITPROC_GREATER,location=LOCATION_HAND|LOCATION_DECK})
	-- --Activate
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	-- e1:SetType(EFFECT_TYPE_ACTIVATE)
	-- e1:SetCode(EVENT_FREE_CHAIN)
	-- e1:SetTarget(s.target)
	-- e1:SetOperation(s.activate)
	-- c:RegisterEffect(e1)
end
s.fit_monster={123107}

function s.ritualfil(c)
	return c:IsCode(123107) and c:IsRitualMonster()
end

function s.filter(c,e,tp,m)
	local cd=c:GetCode()
	if not c:IsCode(123107) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	if m:IsContains(c) then
		m:RemoveCard(c)
		result=m:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
		m:AddCard(c)
	else
		result=m:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
	end
	return result
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND + LOCATION_DECK,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND + LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND + LOCATION_DECK,0,1,1,nil,e,tp,mg)
	if #tg>0 then
		local tc=tg:GetFirst()
		mg:RemoveCard(tc)
		local mat=nil
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
		else
			mat=aux.SelectUnselectGroup(mg,e,tp,1,tc:GetLevel(),s.Check(tc,tc:GetLevel()),1,tp,HINTMSG_RELEASE,s.Finishcon(tc,tc:GetLevel()))
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function s.Check(sc,lv)
	local chk=function(g,c) return g:GetSum(Card.GetRitualLevel,sc) - (Card.GetRitualLevel)(c,sc)<=lv end
	return function(sg,e,tp,mg,c)
		local res=chk(sg,c)
		if not res then return false,true end
		local stop=false
		if res and not stop then
			Duel.SetSelectedCard(sg)
			res=sg:CheckWithSumGreater(Card.GetRitualLevel,lv,sc)
			local stop=false
			res=res and Duel.GetMZoneCount(tp,sg,tp)>0
		end
		return res,stop
	end
end
function s.Finishcon(sc,lv)
	return function(sg,e,tp,mg)
		Duel.SetSelectedCard(sg)
		return sg:CheckWithSumGreater(Card.GetRitualLevel,lv,sc)
	end
end
